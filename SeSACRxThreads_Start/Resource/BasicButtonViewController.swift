//
//  BasicButtonViewController.swift
//  RXswiftBasic0730
//
//  Created by 이윤지 on 7/31/24.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class BasicButtonViewController: UIViewController {
    let customButton = UIButton()
    let customLabel = UILabel()
    let customTextField = UITextField()
    let secondaryLabel = UILabel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // 각 예제 함수 호출 (하나씩 테스트)
        firstExample()
        // secondExample()
        // thirdExample()
        // fourthExample()
        // fifthExample()
        // sixthExample()
        // seventhExample()
        // eighthExample()
        // ninthExample()
    }

    private func configureView() {
        view.addSubview(customButton)
        view.addSubview(customLabel)
        view.addSubview(customTextField)
        view.addSubview(secondaryLabel)

        customButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        customLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(100)
        }

        customTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(customLabel.snp.bottom).offset(20)
        }

        secondaryLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(customTextField.snp.bottom).offset(20)
        }

        customTextField.backgroundColor = .magenta
        secondaryLabel.backgroundColor = .lightGray
        view.backgroundColor = .white
        customButton.backgroundColor = .blue
        customLabel.backgroundColor = .lightGray
    }
}


extension BasicButtonViewController {
    func firstExample() {
        customButton.rx.tap
            .subscribe { [weak self] _ in
                self?.customLabel.text = "버튼을 클릭했어요"
                print("Next event")
            }
            .disposed(by: disposeBag)
    }
    
    func secondExample() {
        customButton.rx.tap
            .map { "버튼을 다시 클릭했어요" }
            .bind(to: secondaryLabel.rx.text, customTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func thirdExample() {
        customButton.rx.tap
            .subscribe { [weak self] _ in
                self?.customLabel.text = "버튼을 클릭했어요"
                print("Next event")
            }
            .disposed(by: disposeBag)
    }
    
    func fourthExample() {
        customButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.customLabel.text = "버튼을 클릭했어요"
                print("Next event")
            }
            .disposed(by: disposeBag)
    }
    
    func fifthExample() {
        customButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.customLabel.text = "버튼이 클릭됐어요"
            }, onDisposed: { owner in
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
    
    func sixthExample() {
        customButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.async {
                    owner.customLabel.text = "버튼이 클릭됐어요"
                }
            }, onDisposed: { owner in
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
    
    func seventhExample() {
        customButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.customLabel.text = "버튼이 클릭됐어요"
            }, onDisposed: { owner in
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }
    
    func eighthExample() {
        customButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.customLabel.text = "버튼이 클릭됐어요"
            })
            .disposed(by: disposeBag)
    }
    
    func ninthExample() {
        customButton.rx.tap
            .map { "버튼을 클릭했어요" }
            .bind(to: customLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

