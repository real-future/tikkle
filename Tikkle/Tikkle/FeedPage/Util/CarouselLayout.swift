//
//  CarouselLayout.swift
//  Tikkle
//
//  Created by 김도현 on 2023/08/16.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {

    public var sideItemScale: CGFloat = 0.7
    public var sideItemAlpha: CGFloat = 0.7
    public var spacing: CGFloat = 0

    // Cell끼리 겹치는 간격 설정
    public var overlapValue: CGFloat = 40
    public var isPagingEnabled: Bool = false

    private var isSetup: Bool = false

    // CollectionView안에 Cell들의 위치를 잡기전에 이 함수가 호출된다.
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }

    // 레이아웃의 기본값들 설정
    // cell간의 간격, 스크롤 방향, 스크롤 속도, section의 inset
    private func setupLayout() {
        guard let collectionView = self.collectionView else {return}

        let collectionViewSize = collectionView.bounds.size

        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2

        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)

        let itemWidth = self.itemSize.width

        let scaledItemOffset =  (itemWidth - itemWidth*self.sideItemScale) / 2
        
        let fullSizeSideItemOverlap = overlapValue + scaledItemOffset
        let inset = xInset
        self.minimumLineSpacing = inset - fullSizeSideItemOverlap

        self.scrollDirection = .horizontal

        self.collectionView?.decelerationRate = .fast
    }

    // CollectionView의 크기가 변할때마다 호출됨
    // true 일 경우 레이아웃을 변경 false 일 경우 CollectionView의 기본 레이아웃 사용
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // UICollectionView의 위치와 크기를 가져와서
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }

    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let collectionView = self.collectionView else {return attributes}

        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset

        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale

        attributes.alpha = alpha

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = CGRectGetMidX(attributes.frame) - CGRectGetMidX(visibleRect)
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform

        return attributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = self.collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
