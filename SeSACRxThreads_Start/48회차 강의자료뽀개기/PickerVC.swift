//
//  PickerVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PickerVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let pickerView = UIPickerView()
    let items = Observable.just([
    "아이템1", "아이템2", "아이템3", "아이템4",
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        
        pickerView.rx.modelSelected(String.self)
            .subscribe(onNext: {models in
            print("선택됨: \(models)")
            })
            .disposed(by: disposeBag)
        
    }
    
}
