//
//  PasswordViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    struct Input {
        let password: Driver<String>
        let tap: Driver<Void>
    }
    
    struct Output {
        let isValid: Driver<Bool>
        let validText: Driver<String>
        let descriptionHidden: Driver<Bool>
        let buttonColor: Driver<UIColor>
        let showAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let isValid = input.password
            .map { $0.count >= 8 }
            .asDriver()
        
        let validText = Driver.just("8자 이상 입력해주세요")
        
        let descriptionHidden = isValid.map { $0 }
        
        let buttonColor = isValid
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .asDriver()
        
        let showAlert = input.tap
            .withLatestFrom(isValid)
            .filter { $0 }
            .map { _ in }
        
        return Output(
            isValid: isValid,
            validText: validText,
            descriptionHidden: descriptionHidden,
            buttonColor: buttonColor,
            showAlert: showAlert
        )
    }
}
