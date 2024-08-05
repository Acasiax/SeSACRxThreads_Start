//
//  Password3VC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class Password3VC: UIViewController {
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
     let nextButton = PointButton(title: "다음")
     let descriptionLabel = UILabel()
     
     let viewModel = PasswordViewModel()
     let disposeBag = DisposeBag()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         view.backgroundColor = .white
         
         configureLayout()
         bind()
     }
     
     func bind() {
         let input = PasswordViewModel.Input(
             password: passwordTextField.rx.text.orEmpty.asDriver(),
             tap: nextButton.rx.tap.asDriver()
         )
         
         let output = viewModel.transform(input: input)
         
         output.validText
             .drive(descriptionLabel.rx.text)
             .disposed(by: disposeBag)
         
         output.isValid
             .drive(nextButton.rx.isEnabled)
             .disposed(by: disposeBag)
         
         output.descriptionHidden
             .drive(descriptionLabel.rx.isHidden)
             .disposed(by: disposeBag)
         
         output.isValid
             .drive(onNext: { [weak self] isValid in
                 self?.nextButton.backgroundColor = isValid ? UIColor.systemPink : UIColor.lightGray
             })
             .disposed(by: disposeBag)
         
         output.showAlert
             .drive(onNext: { [weak self] in
                 let alert = UIAlertController(title: "알림", message: "다음 화면으로 이동합니다.", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "확인", style: .default))
                 self?.present(alert, animated: true)
             })
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
             make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
             make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
         }
     }
}
