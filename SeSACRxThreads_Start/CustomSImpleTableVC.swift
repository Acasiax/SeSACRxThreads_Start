//
//  CustomSImpleTableVC.swift
//  RXswiftBasic0730
//
//  Created by 이윤지 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimpleTableViewExampleViewController: UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        

        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        //MARK: - 여기서부터 rx
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "행 \(row) - 값 \(element)"
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                self.presentAlert("선택된 값: \(value)")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                self.presentAlert("디테일 탭됨 @ \(indexPath.section), \(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

