//
//  PhoneNumberVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignTextField: UITextField {
    init(placeholderText: String) {
        super.init(frame: .zero)
        placeholder = placeholderText
        borderStyle = .roundedRect
        keyboardType = .numberPad
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PhoneViewController: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "전화번호는 10자리 이상이어야 합니다."
        label.isHidden = true
        return label
    }()
    let nextButton = PointButton(title: "다음")
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
        let phoneText = phoneTextField.rx.text.orEmpty.share()

        phoneText
            .map { $0.count >= 10 }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        phoneText
            .map { $0.count >= 10 ? UIColor.blue : UIColor.lightGray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        phoneText
            .map { $0.count > 10 }
            .bind(to: warningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        phoneText
            .map { $0.allSatisfy { $0.isNumber } }
            .subscribe(onNext: { [weak self] isValid in
                if !isValid {
                    self?.showAlert(message: "숫자만 입력 가능합니다.")
                    self?.phoneTextField.text = String(self?.phoneTextField.text?.filter { $0.isNumber } ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
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

class NicknameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
