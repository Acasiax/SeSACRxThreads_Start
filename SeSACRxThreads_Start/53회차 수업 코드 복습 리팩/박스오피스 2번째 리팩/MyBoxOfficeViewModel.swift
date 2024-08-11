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
        let movieList: Observable<[DailyBoxOfficeList]> // 테이블뷰
        let recentList: Observable<[String]> // 컬렉션뷰
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let BoxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        input.recentText
            .subscribe(with: self) { owner, value in
                print("뷰모델 트랜스폼", value)
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        
        //검색 엔터키 클릭 시 서버 통신 진행
        //MARK: - 옵져버블안에 옵져버블에 또 있다!
        // >> Obervable<Observable<Value>>
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
        
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240701
                }
                return intText
            }
            .map { return "\($0)"}
            .flatMap { value in
                NetworkManager.shared.callBoxOffice(date: value)
            } //Obervable<Movie>
            .subscribe(with: self ,onNext: { owner, movie in
                dump(movie.boxOfficeResult.dailyBoxOfficeList)
                
                BoxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
                
            }, onError: { owner, error in
                print("error: \(error)")
            }, onCompleted: { owner in
                print("Completed")
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)
        
        
        return Output(movieList: BoxOfficeList, recentList: recentList)
    }
}



