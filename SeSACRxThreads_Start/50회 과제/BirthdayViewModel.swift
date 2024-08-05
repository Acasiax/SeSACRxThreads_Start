//
//  BirthdayViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

// Driver는 공유 상태를 가집니다. 즉, 여러 구독자가 있어도 하나의 소스로부터 이벤트를 받습니다. 이는 효율성을 높이고, 불필요한 중복 작업을 줄여줍니다.
class BirthdayViewModel {
    
    struct Input {
        let date: Observable<Date>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let year: Driver<Int>
        let month: Driver<Int>
        let day: Driver<Int>
        let infoText: Driver<String>
        let infoColor: Driver<UIColor>
        let buttonEnabled: Driver<Bool>
        let buttonBackgroundColor: Driver<UIColor>
        let showAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let calendar = Calendar.current
        
        let components = input.date
            .map { calendar.dateComponents([.day, .month, .year], from: $0) }
            .share(replay: 1)
        
        let year = components.map { $0.year! }.asDriver(onErrorJustReturn: 0)
        let month = components.map { $0.month! }.asDriver(onErrorJustReturn: 0)
        let day = components.map { $0.day! }.asDriver(onErrorJustReturn: 0)
        
        let age = input.date
            .map { calendar.dateComponents([.year], from: $0, to: Date()).year! }
            .asDriver(onErrorJustReturn: 0)
        
        let infoText = age.map { $0 >= 17 ? "가입이 가능한 나이 입니다." : "만 17세 이상만 가입이 가능합니다." }
        let infoColor = age.map { $0 >= 17 ? UIColor.blue : UIColor.red }
        let buttonEnabled = age.map { $0 >= 17 }
        let buttonBackgroundColor = age.map { $0 >= 17 ? UIColor.blue : UIColor.lightGray }
        
        let showAlert = input.tap.asObservable()
            .withLatestFrom(age)
            .filter { $0 >= 17 }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            year: year,
            month: month,
            day: day,
            infoText: infoText.asDriver(onErrorJustReturn: ""),
            infoColor: infoColor.asDriver(onErrorJustReturn: .red),
            buttonEnabled: buttonEnabled.asDriver(onErrorJustReturn: false),
            buttonBackgroundColor: buttonBackgroundColor.asDriver(onErrorJustReturn: .lightGray),
            showAlert: showAlert
        )
    }
}
