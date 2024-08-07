//
//  Bucket3ViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class Bucket3ViewModel {
    
    let disposeBag = DisposeBag()
    
    // 테이블뷰 데이터
    let items = BehaviorRelay<[Bucket3Item]>(value: [
        Bucket3Item(title: "낮잠자기", isChecked: false, isFavorite: false),
        Bucket3Item(title: "수영하기", isChecked: false, isFavorite: false),
        Bucket3Item(title: "치킨먹기", isChecked: false, isFavorite: false),
        Bucket3Item(title: "신발사기", isChecked: false, isFavorite: false),
        Bucket3Item(title: "이불세탁하기", isChecked: false, isFavorite: false)
    ])
    
    // 필터링된 아이템
       let filteredItems = BehaviorRelay<[Bucket3Item]>(value: [])
    
    // 컬렉션뷰 데이터
    private var recentItems = [Bucket3Item]()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let items: Observable<[Bucket3Item]> // 테이블뷰
        let recentItems: Observable<[Bucket3Item]> // 컬렉션뷰
    }
    
    func transform(input: Input) -> Output {
        let recentItemsSubject = BehaviorSubject(value: recentItems)
        
        input.recentText
            .subscribe(with: self) { owner, title in
                print("뷰모델 트랜스폼", title)
                let newItem = Bucket3Item(title: title, isChecked: false, isFavorite: false)
                owner.recentItems.append(newItem)
                recentItemsSubject.onNext(owner.recentItems)
            }.disposed(by: disposeBag)
        
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("뷰모델 서치버튼 탭 인식")
            }.disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }.disposed(by: disposeBag)
        
        return Output(items: items.asObservable(), recentItems: recentItemsSubject.asObservable())
    }
}
