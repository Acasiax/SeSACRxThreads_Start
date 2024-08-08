//
//  PhoneViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let phoneNumber: Observable<String>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let buttonColor: Observable<UIColor>
        let warningHidden: Observable<Bool>
        let showAlert: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        let isValid = input.phoneNumber
            .map { $0.count >= 10 }
            .share(replay: 1)
        
        let buttonColor = isValid
            .map { $0 ? UIColor.blue : UIColor.lightGray }
            .share(replay: 1)
        
        let warningHidden = input.phoneNumber
            .map { $0.count > 10 }
            .share(replay: 1)
        
        let showAlert = input.phoneNumber
            .map { $0.allSatisfy { $0.isNumber } ? nil : "숫자만 입력 가능합니다." }
            .share(replay: 1)
        
        return Output(
            isValid: isValid,
            buttonColor: buttonColor,
            warningHidden: warningHidden,
            showAlert: showAlert
        )
    }
}
