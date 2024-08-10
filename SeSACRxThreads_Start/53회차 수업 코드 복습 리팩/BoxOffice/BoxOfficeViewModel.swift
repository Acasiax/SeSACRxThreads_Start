//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

/*
 Observable Create.
 Network.. AF.request.. >>
 - Memory Leak
 - RxSwift Single
 
 
 */


class BoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    
//    // 테이블뷰 데이터
//    private let movieList: Observable<[String]> = Observable.just(["테스트1", "테스트2", "테스트3"])
    
    // 컬렉션뷰 데이터
    private var recentList = ["b", "a"]
    
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
    
            .withLatestFrom(input.searchText) //유저가 입력한 글자가 텍스트인지 이 값에 따라 달라짐
         //   .debug("체크1")
 
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240701
                }
                return intText
            } //20240701 값이 예외적으로 리턴
           // .debug("체크2")
            .map { return "\($0)"} //20240701
        //flatMap은 옵져버블을 한번 더 풀어줌?
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
        

//        
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)
        
        
        return Output(movieList: BoxOfficeList, recentList: recentList)
    }
}


