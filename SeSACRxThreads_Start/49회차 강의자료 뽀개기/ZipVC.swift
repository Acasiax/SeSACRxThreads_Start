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

//Zip은 만약 한 관찰자만 보고를 하고, 다른 관찰자가 보고하지 않는다면 Zip은 결과를 내놓지 않아.
// 근데 CombineLatest

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
    
    
    //MARK: -  Zip을 사용하여 멘토 이름과 나이를 동시에 출력함 Zip은 두 관찰자가 모두 보고할 때만 결과를 내놓는거 기억하기!!
    private func zipExample() {
        // Zip을 사용하여 멘토 이름과 나이를 동시에 출력하기
        Observable.zip(mentorObservable, ageObservable)
            .subscribe(onNext: { name, age in
                print("\(name), \(age)")
            })
            .disposed(by: disposeBag)
    }
    
    
   
    //MARK: - Zip은 두 관찰자가 모두 보고할 때만 결과를 내놓는 반면, CombineLatest는 각 관찰자가 가장 최근에 보고한 값을 쌍으로 만들어 결과를 내놓는 거 기억하기!!
    
    private func combineLatestExample() {
          // CombineLatest를 사용하여 멘토 이름과 나이를 동시에 출력함
          // CombineLatest는 가장 최근의 값을 쌍으로 만들어 결과를 내놓음
          Observable.combineLatest(mentorObservable, ageObservable)
              .subscribe(onNext: { name, age in
                  print("\(name), \(age)")
              })
              .disposed(by: disposeBag)
      }
}



