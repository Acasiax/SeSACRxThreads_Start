//
//  Password3ViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class Password3ViewModel {
    
    struct Input {
        let password: Driver<String>
        let tap: Driver<Void>
    }
    
    struct Output {
        let validText: Driver<String>
        let isValid: Driver<Bool>
        let descriptionHidden: Driver<Bool>
        let showAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.password.map { $0.count >= 8 }
        
        let validText = Driver.just("8자 이상 입력해주세요")
        
        let descriptionHidden = validation.map { $0 }
        
        let showAlert = input.tap
        
        return Output(
            validText: validText,
            isValid: validation,
            descriptionHidden: descriptionHidden,
            showAlert: showAlert
        )
    }
}
