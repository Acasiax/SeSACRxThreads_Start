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

class SimpleShoppingListViewController: BaseViewController, UITableViewDelegate {
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    // 쇼핑 아이템 BehaviorRelay로 공부
    let items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(title: "그림툭 구매하기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "사이다 구매", isChecked: true, isFavorite: false),
        ShoppingItem(title: "아이패드 케이스 최저가 알아보기", isChecked: true, isFavorite: true),
        ShoppingItem(title: "양말", isChecked: true, isFavorite: true)
    ])
    
    // 필터된 아이템
    let filteredItems = BehaviorRelay<[ShoppingItem]>(value: [])
    
    // MARK: - 뷰 디드로드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        bindTableViewData()
        handleTableViewSelection()
        bindSearchBar()
        filteredItems.accept(items.value) // 초기 데이터 설정하자
    }
    
    // MARK: - 뷰 설정
    
    private func setupView() {
        self.title = "쇼핑"
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Add Subviews
    
    override func addSubviews() {
        searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    // MARK: - Setup Auto Layout
    
    override func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 데이터 바인딩
    
    private func bindTableViewData() {
        filteredItems.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, item, cell) in
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
        
        // 버튼의 터치 이벤트를 처리하는 구독은 재사용 시마다 새로 추가되지 않도록 설정
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
        filteredItems.accept(currentItems) // 필터된 데이터도 갱신~
    }

    // MARK: - 체크 토글

    private func toggleChecked(at index: Int) {
        var currentItems = items.value
        currentItems[index].isChecked.toggle()
        items.accept(currentItems)
        filteredItems.accept(currentItems) // 필터된 데이터도 갱신~
    }

    // MARK: - 검색 바인딩
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, query in
                owner.filterItems(with: query)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 아이템 필터링
    
    private func filterItems(with query: String) {
        let allItems = items.value
        if query.isEmpty {
            filteredItems.accept(allItems)
        } else {
            let filtered = allItems.filter { $0.title.contains(query) }
            filteredItems.accept(filtered)
        }
    }
}
