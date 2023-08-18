//
//  TikklePageViewController.swift
//  Tikkle
//
//  Created by 김도현 on 2023/08/15.
//

import UIKit

class TikklePageViewController: UIViewController {
    
    var tikkle: Tikkle?
    
    var tikkleList: TikkleListManager = TikkleListManager()
    
    @IBOutlet weak var TikklePageImage: UIImageView!
    @IBOutlet weak var TikklePageTitle: UILabel!
    @IBOutlet weak var TikklePageDaysLabel: UILabel!
    @IBOutlet weak var TikklePageDateLabel: UILabel!
    @IBOutlet weak var TikklePageInfo: UILabel!
    
    @IBOutlet weak var TikklePageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        uiSet()
        
        TikklePageCollectionView.delegate = self
        TikklePageCollectionView.dataSource = self
    }
    
    //MARK: - TikklePage NavigationBar 커스텀
    func navigationSetting() {
        guard let naviBar = navigationController?.navigationBar else { return }
        let naviBarAppearance = UINavigationBarAppearance()
        naviBarAppearance.backgroundColor = .black
        naviBar.standardAppearance = naviBarAppearance
        naviBar.scrollEdgeAppearance = naviBarAppearance
        
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let deleteImage = UIImage(named: "delete")
        let deleteImageview = UIImageView(image: deleteImage)
        deleteImageview.contentMode = .scaleAspectFit
        
        //MARK: -
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: deleteImage, style: .plain, target: self, action: #selector(TikklePageViewController.deleteAlert))
    }
    
    //MARK: -
    @objc func deleteAlert() {
        let deleteAlert = UIAlertController(title: "정말로 포기하시겠습니까?", message: nil, preferredStyle: .alert)
        
        let deleteCancelBtn = UIAlertAction(title: "취소", style: .cancel)
        let deleteOKBtn = UIAlertAction(title: "포기", style: .default) { [weak self] _ in
            guard let self, let tikkle else { return }
            
            tikkleList.deleteTikkle(where: tikkle.id)
            self.navigationController?.popViewController(animated: true)
        }
        
        deleteAlert.addAction(deleteCancelBtn)
        deleteAlert.addAction(deleteOKBtn)
        
        self.present(deleteAlert, animated: true)
    }
    
    
    //MARK: - TikklePage Image, Title, Info 가져오기
    func uiSet() {
        guard let tikkle else { return }
        TikklePageImage.image = tikkle.image
        TikklePageImage.contentMode = .scaleAspectFill
        TikklePageImage.layer.cornerRadius = TikklePageImage.frame.height / 2
        TikklePageTitle.text = tikkle.title
        TikklePageInfo.text = tikkle.description
    }
}

//MARK: - TikklePage CollectionView Setting
extension TikklePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tikkle?.stampList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TikklePageCollectionView.dequeueReusableCell(withReuseIdentifier: "TikklePageCollectionViewCell", for: indexPath) as! TikklePageCollectionViewCell
        
        cell.TikklePageCellName.text = tikkle?.stampList[indexPath.row].title
        cell.cellUISetting(tikkle: tikkle, index: indexPath.row)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = TikklePageCollectionView.frame.width / 3 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
}
