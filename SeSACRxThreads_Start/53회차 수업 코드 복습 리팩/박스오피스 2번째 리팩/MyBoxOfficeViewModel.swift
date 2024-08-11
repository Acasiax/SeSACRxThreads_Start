//
//  MyBoxOfficeViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyBoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    
    //컬렉션뷰 데이터
    private var recentList = ["b","a"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        
        //테이블 셀 클릭 시 들어오는 글자. 컬렉션뷰에 업데이트
        let recentText: PublishSubject<String>
        
    }
    
    struct Output {
        let movieList: Observable<[DailyBoxOfficeList]>
        let recentList: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
    
    
    
}
