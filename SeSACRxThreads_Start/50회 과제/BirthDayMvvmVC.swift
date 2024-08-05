//
//  BirthDayMvvmVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayMvvmVC: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        // 입력을 뷰모델에 전달
        let input = BirthdayViewModel.Input(
            date: birthDayPicker.rx.date.asObservable(),
            tap: nextButton.rx.tap.asControlEvent()
        )
        
        let output = viewModel.transform(input: input)
        
        // 출력을 뷰와 바인딩
        output.year
            .map { "\($0)년" }
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .map { "\($0)월" }
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
            .map { "\($0)일" }
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.infoText
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.infoColor
            .drive(infoLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.buttonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.buttonBackgroundColor
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.showAlert
            .drive(onNext: { [weak self] in
                let alert = UIAlertController(title: "알림", message: "완료", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

