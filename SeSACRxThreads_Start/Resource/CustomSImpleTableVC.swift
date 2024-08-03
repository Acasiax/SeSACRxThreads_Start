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


struct ShoppingItem0 {
    var title: String
    var isChecked: Bool
    var isFavorite: Bool
}

class SimpleShoppingListViewController0: UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let items = BehaviorRelay<[ShoppingItem0]>(value: [
        ShoppingItem0(title: "그림툭 구매하기", isChecked: true, isFavorite: true),
        ShoppingItem0(title: "사이다 구매", isChecked: true, isFavorite: false),
        ShoppingItem0(title: "아이패드 케이스 최저가 알아보기", isChecked: true, isFavorite: true),
        ShoppingItem0(title: "양말", isChecked: true, isFavorite: true)
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "쇼핑"
        view.backgroundColor = .white
        
        // 테이블 뷰 설정
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 데이터 바인딩
        items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, item, cell) in
            cell.textLabel?.text = item.title
            cell.accessoryView = self.createAccessoryView(isFavorite: item.isFavorite, index: row)
        }
        .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                var currentItems = self.items.value
                currentItems[indexPath.row].isChecked.toggle()
                self.items.accept(currentItems)
            })
            .disposed(by: disposeBag)
    }
    
    func createAccessoryView(isFavorite: Bool, index: Int) -> UIView {
        let button = UIButton(type: .system)
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        var currentItems = items.value
        currentItems[index].isFavorite.toggle()
        items.accept(currentItems)
    }
}
