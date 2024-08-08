//
//  SwitchVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SwitchVC: UIViewController {
    let disposeBag = DisposeBag()
    let toggleSwitch = UISwitch()
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(toggleSwitch)
        view.addSubview(statusLabel)
        
        toggleSwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(toggleSwitch.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
//        toggleSwitch.rx.isOn
//            .map{ $0 ? "스위치이스 온" : "스위치이스 오프" }
//            .bind(to: statusLabel.rx.text)
//            .disposed(by: disposeBag)
        
        Observable.of(false)
            .bind(to: toggleSwitch.rx.isOn)
            .disposed(by: disposeBag)
            
        
    }
    
    
}
