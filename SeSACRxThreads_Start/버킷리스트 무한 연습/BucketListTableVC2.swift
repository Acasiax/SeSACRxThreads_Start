//
//  BucketListTableVC2.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct BucketItem {
    var title: String
    var isChecked: Bool
    var isFavorite: Bool
}

class BucketListTableVC2: UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var addItemTextField: UITextField!
    var addItemButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let items = BehaviorRelay<[BucketItem]>(value: [
        BucketItem(title: "낮잠자기", isChecked: false, isFavorite: false),
        BucketItem(title: "수영하기", isChecked: false, isFavorite: false),
        BucketItem(title: "치킨먹기", isChecked: false, isFavorite: false),
        BucketItem(title: "신발사기", isChecked: false, isFavorite: false),
        BucketItem(title: "이불세탁하기", isChecked: false, isFavorite: false)
    ])
    
    let filteredItems = BehaviorRelay<[BucketItem]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        bindTableViewData()
        bindAddItem()
        bindSearchBar()
        
        items
            .bind(to: filteredItems)
            .disposed(by: disposeBag)
    }
    
    func setupView() {
        self.title = "쇼핑"
        view.backgroundColor = .white
    }
    
    func addSubviews() {
        tableView = UITableView()
        searchBar = UISearchBar()
        addItemTextField = UITextField()
        addItemButton = UIButton(type: .system)
        
        addItemTextField.placeholder = "무엇을 구매하실 건가요?"
        addItemTextField.borderStyle = .roundedRect
        
        addItemButton.setTitle("추가", for: .normal)
        
        view.addSubview(addItemTextField)
        view.addSubview(addItemButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        addItemTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(addItemButton.snp.left).offset(-8)
        }
        
        addItemButton.snp.makeConstraints { make in
            make.centerY.equalTo(addItemTextField)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(50)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(addItemTextField.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
    }
    
    func bindTableViewData() {
        filteredItems
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.title
                cell.accessoryView = self.createAccessoryView(isFavorite: item.isFavorite, index: row)
            }
            .disposed(by: disposeBag)
    }
    
    func bindAddItem() {
        addItemButton.rx.tap
            .withLatestFrom(addItemTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .subscribe(with: self, onNext: { owner, text in
                var currentItems = owner.items.value
                let newItem = BucketItem(title: text, isChecked: false, isFavorite: false)
                currentItems.append(newItem)
                owner.items.accept(currentItems)
                owner.addItemTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    func handleTableViewSelection() {
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.toggleChecked(at: indexPath.row)
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
    }
    
    private func createAccessoryView(isFavorite: Bool, index: Int) -> UIView {
        let button = UIButton(type: .system)
        let image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tag = index
        
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleFavorite(at: index)
            }
            .disposed(by: disposeBag)
        
        return button
    }
    
    private func toggleFavorite(at index: Int) {
        var currentItems = items.value
        currentItems[index].isFavorite.toggle()
        items.accept(currentItems)
        filteredItems.accept(currentItems)
    }
    
    //accept 메서드는 BehaviorRelay 또는 PublishRelay 같은 RxSwift의 Relay 타입에 새로운 값을 설정할 때 사용됩니다. accept 메서드를 호출하면 Relay의 현재 값이 업데이트되고, Relay가 구독된 모든 구독자에게 새 값이 방출됩니다.
    func toggleChecked(at index: Int) {
        var currentItems = items.value
        currentItems[index].isChecked.toggle()
        items.accept(currentItems)
        filteredItems.accept(currentItems)
    }
    
    // MARK: - 검색 바인딩
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged() //연속된 중복 값을 필터링하는 데 사용됩니다. 즉, 이 연산자는 이전 값과 동일한 값이 연속적으로 발생하면 그 값을 무시하고, 이전 값과 다른 새로운 값이 발생할 때만 구독자에게 알립니다.
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
