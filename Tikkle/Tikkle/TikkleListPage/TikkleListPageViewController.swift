//
//  TikkleListPageViewController.swift
//  Tikkle
//
//  Created by 김도현 on 2023/08/15.
//

import UIKit

class TikkleListPageViewController: UIViewController {
    
    //MARK: -티끌리스트매니저 모델 생성 (이제부터 이 매니저 모델을 통해 데이터를 매니징할 수 있음)
    var tikkleListManager = TikkleListManager()
    
    
    //MARK: -TikkleListPage ViewController 스토리보드 요소들 연결
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var createTikkleButton: UIButton!
    
    
    //MARK: -TikkleListPage ViewController 앱 실행될 때 처음 실행되는 곳
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatas()
        seupTableView()
        setUI()
    }
    
    
    //MARK: -TikkleListPage ViewController viewDidLoad 정리 함수들 모음
    //테이블뷰 세팅 함수. 위의 viewDidLoad 깔끔하게 사용 위함.
    func seupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //데이터 세팅 함수. 위의 viewDidLoad 깔끔하게 사용 위함.
    func setupDatas() {
        tikkleListManager.makeTikkleListDatas()//데이터(더미데이터) 생성
    }
    
    //UI 세팅 함수.위의 viewDidLoad 깔끔하게 사용 위함.
    func setUI() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold), // semibold 굵기 설정
            .foregroundColor: UIColor.black
        ]
        let attributedText = NSAttributedString(string: "+ 생성하기", attributes: attributes)
        createTikkleButton.setAttributedTitle(attributedText, for: .normal)
        createTikkleButton.backgroundColor = UIColor.mainColor
        createTikkleButton.layer.cornerRadius = 17
        
        view.backgroundColor = .black
        
        mainLabel.text = "나의 Tikkle 모음"
        subLabel.text = "티끌 모아 태산 !"
        mainLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        subLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        subLabel.textColor = UIColor.subTitleColor
    }
}



//MARK: -테이블 뷰 행을 탭할 때 실행
extension TikkleListPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: -테이블 뷰 사용시 필수 구현해야 하는 메소드
extension TikkleListPageViewController: UITableViewDataSource {
    //TikkleListPage 테이블뷰 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tikkleListManager.getTikkleList().count
        
    }
    
    //셀에 데이터 연결하기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TikkleListTableViewCell
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // 행간 설정
        
        
        //titleLabel---------------------------------------------------------------------
        cell.titleLabel.font = .systemFont(ofSize: 24)
        cell.titleLabel.text = tikkleListManager[indexPath.row].title.description
        
        
        //tikkleImage---------------------------------------------------------------------
        cell.tikkleImage.image = tikkleListManager[indexPath.row].image
        cell.tikkleImage.contentMode = .scaleAspectFill //이미지 채우는 방식
        
        
        //isPrivateButton-----------------------------------------------------------------
        if DataList.list[indexPath.row].isPrivate {
            cell.isPrivateButton.addSubview(CustomButton.makePrivateTrueButton())
        } else {
            cell.isPrivateButton.addSubview(CustomButton.makePrivateFalseButton())
        }
        
        
        //isSharedProjectButton------------------------------------------------------------
        if DataList.list[indexPath.row].isSharedProject {
            cell.isSharedProjectButton.addSubview(CustomButton.makeTogetherButton())
        }
        
        
        //percentLabel---------------------------------------------------------------------
        //isCompletion이 true인 Stamp의 개수
        let completedCount = tikkleListManager[indexPath.row].stampList.filter { $0.isCompletion }.count
        let totalCount = tikkleListManager[indexPath.row].stampList.count
        
        // percentLabel : 퍼센트 값 계산
        let percentage: Double
        if totalCount != 0 { // 나눌 값이 0이면 안돼!
            percentage = (Double(completedCount) / Double(totalCount)) * 100.0
        } else {
            percentage = 0
        }
        
        //percentLabel에 설정
        cell.percentLabel.text = "\(Int(percentage))%"
        
        
        
        //graphImage-----------------------------------------------------------------------
        //위에서 계산한 퍼센티지에 따라 이미지 변경
        var imageName: String
        switch percentage {
        case 0..<10:
            imageName = "graph0"
        case 10..<20:
            imageName = "graph1"
        case 20..<30:
            imageName = "graph2"
        case 30..<40:
            imageName = "graph3"
        case 40..<50:
            imageName = "graph4"
        case 50..<60:
            imageName = "graph5"
        case 60..<70:
            imageName = "graph6"
        case 70..<80:
            imageName = "graph7"
        case 80..<90:
            imageName = "graph8"
        case 90..<100:
            imageName = "graph9"
        case 100:
            imageName = "graph10"
        default:
            imageName = "graph0" // 예외 상황
            print("graphImage Error")
        }
        
        //graphImage에 설정
        cell.graphImage.image = UIImage(named: imageName)
        
        
        return cell
    }
}
