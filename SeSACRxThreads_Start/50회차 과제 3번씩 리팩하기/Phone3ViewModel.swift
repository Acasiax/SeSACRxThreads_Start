//
//  Phone3ViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class Phone3ViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let phoneNumber: Observable<String>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let warningHidden: Observable<Bool>
        let showAlert: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        let isValid = input.phoneNumber
            .map { $0.count >= 10 }
            .share(replay: 1)
        
        let warningHidden = input.phoneNumber
            .map { $0.count >= 10 }
            .share(replay: 1)
        
        let showAlert = input.phoneNumber
            .map { $0.allSatisfy { $0.isNumber } ? nil : "숫자만 입력 가능합니다." }
            .share(replay: 1)
        
        return Output(
            isValid: isValid,
            warningHidden: warningHidden,
            showAlert: showAlert
        )
    }
}

