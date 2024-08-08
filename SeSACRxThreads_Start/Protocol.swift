//
//  Protocol.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/8/24.
//

import Foundation
import UIKit

// MARK: - ReusableIdentifier 프로토콜
protocol ReusableIdentifier {
    static var identifier: String { get }
}

// MARK: - UIView 확장
extension UIView: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}


