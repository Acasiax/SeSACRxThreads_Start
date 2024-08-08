//
//  TableViewVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TableViewVC: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let items = Observable.just([
        "아이템1", "아이템2", "아이템3", "아이템4"
    ])
    let simpleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(simpleLabel)
        
        simpleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        tableView.snp.makeConstraints { make in 
            make.top.equalTo(simpleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        // tableView에 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // items Observable을 tableView에 바인딩
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (row, item, cell) in
                
                cell.textLabel?.text = "\(item) @ row \(row)"
               
            }
            .disposed(by: disposeBag)
        
        // tableView의 선택된 모델을 관찰하고 라벨의 텍스트로 바인딩
        tableView.rx.modelSelected(String.self)
            .map { data in "\(data)를 클릭했습니다." }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
