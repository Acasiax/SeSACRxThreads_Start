//
//  Password3ViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class Password3ViewModel {
    
    struct Input {
        let passwordText: Driver<String>
        let tap: Driver<Void>
    }
    
    struct Output {
        let validText: Driver<String>
        let isValid: Driver<Bool>
        let isDescriptionHidden: Driver<Bool>
        let nextButtonColor: Driver<UIColor>
        let showAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.passwordText.map { $0.count >= 8 }
        
        let validText = Driver.just("8자 이상 입력해주세요")
        
        let isDescriptionHidden = validation.map { !$0 }
        
        let nextButtonColor = validation.map {$0 ? UIColor.systemPink : UIColor.lightGray}
        
        let showAlert = input.tap
        
        return Output(validText: validText, isValid: validation, isDescriptionHidden: isDescriptionHidden, nextButtonColor: nextButtonColor, showAlert: showAlert
        )
        
        
    }
}
