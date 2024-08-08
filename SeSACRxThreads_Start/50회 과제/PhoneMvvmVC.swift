//
//  PhoneMvvmVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class PhoneMvvmVC: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "전화번호는 10자리 이상이어야 합니다."
        label.isHidden = true
        return label
    }()
    let nextButton = PointButton(title: "다음")
    
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        setupInitialText()
        bind()
    }
    
    func setupInitialText() {
        phoneTextField.text = "010"
    }
    
    func bind() {
        let input = PhoneViewModel.Input(
            tap: nextButton.rx.tap.asControlEvent(),
            phoneNumber: phoneTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.warningHidden
            .bind(to: warningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showAlert
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
                self?.phoneTextField.text = self?.phoneTextField.text?.filter { $0.isNumber }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { _ in
                self.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(warningLabel)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(warningLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}



