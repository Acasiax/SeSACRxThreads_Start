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
    // 클래스의 속성을 선언
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    // 쇼핑 아이템 BehaviorRelay
    let items = BehaviorRelay<[BucketItem]>(value: [
        BucketItem(title: "낮잠자기", isChecked: false, isFavorite: false),
        BucketItem(title: "수영하기", isChecked: false, isFavorite: false),
        BucketItem(title: "치킨먹기", isChecked: false, isFavorite: false),
        BucketItem(title: "신발사기", isChecked: false, isFavorite: false),
        BucketItem(title: "이불세탁하기", isChecked: false, isFavorite: false)
    ])
    
    // 필터링된 아이템
    let filteredItems = BehaviorRelay<[BucketItem]>(value: [])

    // MARK: - 뷰 디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        bindTableViewData()
        
        // items를 filteredItems로 바인딩하여 초기 데이터를 설정
        items
            .bind(to: filteredItems)
            .disposed(by: disposeBag)
    }
    
    func setupView() {
        self.title = "쇼핑"
        view.backgroundColor = .white
    }
    
    func addSubviews() {
        // 테이블 뷰 생성 및 설정
        tableView = UITableView()
        searchBar = UISearchBar()
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.backgroundColor = .orange.withAlphaComponent(0.5)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
            }
            .disposed(by: disposeBag)
    }
}
