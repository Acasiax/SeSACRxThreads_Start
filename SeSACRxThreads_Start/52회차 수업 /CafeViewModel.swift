//
//  CafeViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeViewModel {
    
    let disposeBag = DisposeBag()
    
    // 테이블뷰 데이터
    private let menuList: Observable<[String]> = Observable.just(["커피", "라떼", "모카"])
    
    // 컬렉션뷰 데이터
    private var recentList = ["에스프레소", "아메리카노"]
    
    struct Input {
        
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        
        // 테이블 셀 클릭 시 들어오는 글자. 컬렉션뷰에 업데이트
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let menuList: Observable<[String]> // 테이블뷰
        let recentList: Observable<[String]> // 컬렉션뷰
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                print("뷰모델 트랜스폼", value)
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("뷰모델 서치버튼 탭 인식")
                
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)
        
        return Output(menuList: menuList, recentList: recentList)
    }
}


