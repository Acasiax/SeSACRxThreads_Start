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
    // UI 컴포넌트
    var tableView: UITableView!
    
    // RxSwift Dispose Bag
    let disposeBag = DisposeBag()
    
    // 쇼핑 아이템
    let items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(title: "그림툭 구매하기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "사이다 구매", isChecked: true, isFavorite: false),
        ShoppingItem(title: "아이패드 케이스 최저가 알아보기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "양말", isChecked: true, isFavorite: true)
    ])
    
    // MARK: - 뷰 디드로드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        bindTableViewData()
        handleTableViewSelection()
    }
    
    // MARK: - 뷰 설정
    
    private func setupView() {
        self.title = "쇼핑"
        view.backgroundColor = .white
    }
    
    // MARK: - 테이블 뷰 설정
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 데이터 바인딩
    
    private func bindTableViewData() {
        items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, item, cell) in
            guard let self = self else { return }
            cell.textLabel?.text = item.title
            cell.accessoryView = self.createAccessoryView(isFavorite: item.isFavorite, index: row)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - 선택 처리
    
    private func handleTableViewSelection() {
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.toggleChecked(at: indexPath.row)
            }, onDisposed: { owner in
                print("Disposed")
            })
            .disposed(by: disposeBag)
    }

    // MARK: - 액세서리 뷰
    
    private func createAccessoryView(isFavorite: Bool, index: Int) -> UIView {
        let button = UIButton(type: .system)
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tag = index
        
        // 버튼의 크기 설정
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        // Rx를 사용하여 버튼의 터치 이벤트 처리
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)
        
        return button
    }
    
    // MARK: - 즐겨찾기 토글
    
    private func toggleFavorite(at index: Int) {
        var currentItems = items.value
        currentItems[index].isFavorite.toggle()
        items.accept(currentItems)
    }

    // MARK: - 체크 토글

    private func toggleChecked(at index: Int) {
        var currentItems = items.value
        currentItems[index].isChecked.toggle()
        items.accept(currentItems)
    }
}
