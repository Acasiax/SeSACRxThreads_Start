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

final class PickerVC: UIViewController {
    
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
        //내가 만든 아이템을 rx를 통하여 데이터피커에 넣는 과정
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element // 각 행의 타이틀로 element 반환
            }
            .disposed(by: disposeBag)
          
        
        // modelSelected(String.self)는 UIPickerView에서 특정 타입(String)의 모델이 선택되었을 때 이를 Observable로 만들어주는 메서드입니다.
        // 즉, 사용자가 UIPickerView에서 아이템을 선택할 때마다 이 Observable이 이벤트를 방출하게 됩니다.
        pickerView.rx.modelSelected(String.self) // 선택된 모델을 관찰
            .subscribe(onNext: {items in // 선택된 모델을 구독
            print("선택됨: \(items)")
            })
            .disposed(by: disposeBag)
    }
    
}
