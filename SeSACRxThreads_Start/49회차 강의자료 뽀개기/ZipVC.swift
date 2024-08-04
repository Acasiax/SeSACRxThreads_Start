//
//  ZipVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ZipViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
  
    let mentorObservable = Observable.of("Hue", "Jack", "Bran", "Den")
    let ageObservable = Observable.of(24, 21, 23, 22)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
       
        bindTableView()
        
        zipExample()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func bindTableView() {
       
        let items = Observable.just([
            "Item 1",
            "Item 2",
            "Item 3",
            "Item 4"
        ])
        
        // 테이블 뷰에 항목들을 표시해요
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
        
        //MARK: - 원래는 이렇게 따로 따로 가져올 수 밖에 없었음
        // 테이블 뷰에서 항목을 선택했을 때
        tableView.rx.itemSelected
            .subscribe { indexPath in
                print("\(indexPath) 선택되었어요")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰에서 선택된 항목의 이름을 가져올 때
        tableView.rx.modelSelected(String.self)
            .subscribe { model in
                print("\(model) 선택되었어요")
            }
            .disposed(by: disposeBag)
        
        
        //MARK: -  Zip을 사용하여 동시에 출력 가능해짐
        
        // Zip을 사용하여 위치와 항목 이름을 동시에 출력하기
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(String.self)
        )
        .subscribe(onNext: { indexPath, model in
            print("\(indexPath), \(model) 선택되었어요")
        }, onDisposed: {
            print("Disposed")
        })
        .disposed(by: disposeBag)
    }
    
    private func zipExample() {
        // Zip을 사용하여 멘토 이름과 나이를 동시에 출력하기
        Observable.zip(mentorObservable, ageObservable)
            .subscribe(onNext: { name, age in
                print("\(name), \(age)")
            })
            .disposed(by: disposeBag)
    }
}
