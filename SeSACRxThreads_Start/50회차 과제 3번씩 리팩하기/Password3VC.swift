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
    
    
    let viewModel = Password3ViewModel()
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        
        configureLayout()
        
        bind()
    }
    
    // 데이터 바인딩 설정 메소드
    func bind() {
        // ViewModel에 전달할 Input 생성
        let input = Password3ViewModel.Input(
            passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
            tap: nextButton.rx.tap.asDriver()
        )
        
        // ViewModel의 transform 메소드를 호출하여 Output 생성
        let output = viewModel.transform(input: input)
        
        // validText의 값을 descriptionLabel의 텍스트에 바인딩
        output.validText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 비밀번호가 8자 이상인지 확인하는 Observable의 값을 nextButton의 isEnabled 속성에 바인딩
        output.isValid
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 설명 라벨의 숨김 여부를 isDescriptionHidden Observable의 값에 바인딩
        output.isDescriptionHidden
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // nextButton의 배경색을 nextButtonColor Observable의 값에 바인딩
        output.nextButtonColor
            .drive(onNext: { [weak self] color in
                self?.nextButton.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        // nextButton이 탭되었을 때 알림을 표시
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
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
