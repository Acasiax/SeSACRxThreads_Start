//
//  BaseViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        // 서브뷰 추가
    }

    func setupLayout() {
        // 제약조건
    }


}
