//
//  CombineLatestVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

//CombineLatest 연산자를 사용하면, 여러 Observable의 최신 값을 결합하여 새로운 Observable을 생성할 수 있다. 각 소스 Observable이 최소 한 번의 next 이벤트를 방출해야만 결합된 Observable에 이벤트가 방출된다는 점을 기억해야 함.
// 결합하려고 하는 각 항목이 모두 최소 1번씩은 next 이벤트를 emit 해야 구독을 시작함을 유의하자!

final class CombineLatestViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let textField1: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "첫 번째 텍스트 입력"
        return textField
    }()
    
    let textField2: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "두 번째 텍스트 입력"
        return textField
    }()
    
    let combinedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "결합된 텍스트가 여기에 표시됩니다"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupBindings()
        runCombineLatestExample()
    }
    
    private func setupUI() {
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(combinedLabel)
        
        textField1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        combinedLabel.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupBindings() {
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty) { text1, text2 in
            return "\(text1) \(text2)"
        }
        .bind(to: combinedLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func runCombineLatestExample() {
        let a = PublishSubject<String>()
        let b = PublishSubject<String>()

        Observable.combineLatest(a, b) { lastA, lastB in
            "\(lastA) \(lastB)"
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

        a.onNext("Hello")    // a 박스에 "Hello"를 넣음
        b.onNext("World")    // b 박스에 "World"를 넣음 (출력: "Hello World")
        a.onNext("RxSwift")  // a 박스에 "RxSwift"를 넣음 (출력: "RxSwift World")
        b.onNext("CombineLatest") // b 박스에 "CombineLatest"를 넣음 (출력: "RxSwift CombineLatest")

        // 출력 결과:
        // Hello World
        // RxSwift World
        // RxSwift CombineLatest
    }
}
