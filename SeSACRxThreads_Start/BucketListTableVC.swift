//
//  BucketListTableVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct ShoppingItem {
    var title: String
    var isChecked: Bool
    var isFavorite: Bool
}

class SimpleShoppingListViewController: UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(title: "그림툭 구매하기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "사이다 구매", isChecked: true, isFavorite: false),
        ShoppingItem(title: "아이패드 케이스 최저가 알아보기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "양말", isChecked: true, isFavorite: true)
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
        
        //셀 선택했을때
        tableView.rx.itemSelected
            .subscribe(onNext:  { indexPath in
                print("선택했어 \(indexPath.row)")
            })
            .disposed(by: disposeBag)
        
    }
    
    func createAccessoryView(isFavorite: Bool, index: Int) -> UIView {
        let button = UIButton(type: .system)
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tag = index
        
        // Rx를 사용하여 버튼의 터치 이벤트 처리
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)
        
        
        return button
        
    }
    
    func toggleFavorite(at index: Int) {
            var currentItems = items.value
            currentItems[index].isFavorite.toggle()
            items.accept(currentItems)
        }
    
}
