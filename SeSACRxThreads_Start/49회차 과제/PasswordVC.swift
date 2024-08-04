//
//  PasswordVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordVC: UIViewController {
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureLayout()
        bind()
    }
    
    func bind() {

        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
      
        let validation = passwordTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
        
  
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .map { !$0 }
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
  
        nextButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "알림", message: "다음 화면으로 이동합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
   
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
