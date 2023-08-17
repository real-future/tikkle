//
//  TikkleListManager.swift
//  Tikkle
//
//  Created by FUTURE on 2023/08/18.
//

import Foundation

//MARK: -데이터매니저
class TikkleListManager {
    
    private var tikkleList: [Tikkle] = []
    

    //빈 배열에 더미데이터 추가
    func makeTikkleListDatas() {
        tikkleList = DataList.list
    }
    
    //전체 티끌판 리스트를 리턴해주는 함수
    func getTikkleList() -> [Tikkle] {
        return tikkleList
    }
    
    //이름으로 특정 리스트를 리턴해주는 함수
    func getTikkle(where title: String) -> Tikkle? {
        return tikkleList.first { $0.title == title }
    }
    
    
    //새로운 티끌판 만들기
    func addTikkle(_ tikkle: Tikkle) {
        tikkleList.append(tikkle)
    }
    
    
    //기존 티끌판 정보 업데이트
    func updateTikkleInfo(index: Int, _ tikkle: Tikkle) {
        if let index = tikkleList.firstIndex(where: { $0.title == tikkle.title }) {
            tikkleList[index] = tikkle
        }
    }
    
    //티끌판 이름으로 해당 티끌판 삭제
    func deleteTikkle(where title: String) {
        tikkleList.removeAll { $0.title == title }
    }
    
    //subscript : 객체의 내부 요소에 접근할 수 있는 짧은 경로(shortcut)를 제공하는 문법
    //사용 법 : 특정 티끌판 리턴해야 할 때 [tikkleListManager.getTikkleList() 대신에 사용]
    subscript(index: Int) -> Tikkle {
        get {
            return tikkleList[index]
        }
        set {
            tikkleList[index] = newValue
        }
    }
}
