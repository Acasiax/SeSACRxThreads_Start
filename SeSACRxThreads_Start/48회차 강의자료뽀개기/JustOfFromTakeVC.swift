//
//  JustOfFromTakeVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class JustOfFromTakeVC: UIViewController {
    let disposeBag = DisposeBag()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        justExample()
        ofExample()
        fromExample()
        takeExample()
    }
    // MARK: - just: 단일 값을 방출
    func justExample() {
        let observable = Observable.just("Hello, RxSwift!")
        
        observable.subscribe { event in
            print("Just Example:", event)
            // Just Example: next(Hello, RxSwift!)
            // Just Example: completed
        }.disposed(by: disposeBag)
    }
      
    //  MARK: - of: 여러 개의 값을 동시에 방출
    func ofExample() {
        let observable = Observable.of("Hello", "RxSwift", "World")
        
        observable.subscribe { event in
            print("Of Example:", event)
            // Of Example: next(Hello)
            // Of Example: next(RxSwift)
            // Of Example: next(World)
            // Of Example: completed
        }.disposed(by: disposeBag)
    }
      
    //  MARK: - from: 배열의 각 요소를 방출
    // 배열을 파라미터로 받아 각 요소를 개별적으로 observable로 리턴
    func fromExample() {
        let array = ["Hello", "RxSwift", "World"]
        let observable = Observable.from(array)
        
        observable.subscribe { event in
            print("From Example:", event)
            // From Example: next(Hello)
            // From Example: next(RxSwift)
            // From Example: next(World)
            // From Example: completed
        }.disposed(by: disposeBag)
    }
      
    //  MARK: - take: 방출된 아이템 중 처음 n개의 아이템을 방출
    func takeExample() {
        let observable = Observable.of(1, 2, 3, 4, 5)
        
        observable
            .take(3)
            .subscribe { event in
                print("Take Example:", event)
                // Take Example: next(1)
                // Take Example: next(2)
                // Take Example: next(3)
                // Take Example: completed
            }.disposed(by: disposeBag)
    }
}
