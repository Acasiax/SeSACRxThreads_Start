//
//  BirthDayVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PointButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        isEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Color {
    static let black: UIColor = .black
    static let white: UIColor = .white
}

class BirthdayViewController: UIViewController {
    
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
    
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        setupInitialDate()
        bind()
    }
    
    func setupInitialDate() {
        let today = Date()
        let components = Calendar.current.dateComponents([.day, .month, .year], from: today)
        
        year.accept(components.year!)
        month.accept(components.month!)
        day.accept(components.day!)
        
        yearLabel.text = "\(components.year!)년"
        monthLabel.text = "\(components.month!)월"
        dayLabel.text = "\(components.day!)일"
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
                
                let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
                
                if age >= 17 {
                    owner.infoLabel.text = "가입이 가능한 나이 입니다."
                    owner.infoLabel.textColor = .blue
                    owner.nextButton.backgroundColor = .blue
                    owner.nextButton.isEnabled = true
                } else {
                    owner.infoLabel.text = "만 17세 이상만 가입이 가능합니다."
                    owner.infoLabel.textColor = .red
                    owner.nextButton.backgroundColor = .lightGray
                    owner.nextButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "알림", message: "완료", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                owner.present(alert, animated: true, completion: nil)
            }
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
