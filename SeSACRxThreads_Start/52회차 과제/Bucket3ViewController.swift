//
//  ToDoListViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Bucket3Item {
    var title: String
    var isChecked: Bool
    var isFavorite: Bool
}


final class Bucket3ViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = Bucket3ViewModel()
    
    let disposeBag = DisposeBag()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func bind() {
        let recentText = PublishSubject<String>()
        
        let input = Bucket3ViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        let output = viewModel.transform(input: input)
        
        // 테이블뷰에 items 바인딩
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: Bucket3TableViewCell.identifier, cellType: Bucket3TableViewCell.self)) { (row, item, cell) in
                cell.titleLabel.text = item.title
                cell.accessoryView = self.createAccessoryView(isFavorite: item.isFavorite, index: row)
            }.disposed(by: disposeBag)
        
        // 컬렉션뷰에 recentItems 바인딩
        output.recentItems
            .bind(to: collectionView.rx.items(cellIdentifier: Buket3CollectionViewCell.identifier, cellType: Buket3CollectionViewCell.self)) { (row, item, cell) in
                cell.label.text = item.title
            }.disposed(by: disposeBag)
        
        // Observable.zip 사용하여 modelSelected와 itemSelected 동시에 처리
        Observable.zip(tableView.rx.modelSelected(Bucket3Item.self), tableView.rx.itemSelected)
            .debug("디버깅")
            .map { "검색어는 \($0.0.title)" }
            .subscribe(with: self) { owner, value in
                recentText.onNext(value)
                print(value)
            }.disposed(by: disposeBag)
        
        // modelSelected 처리
        tableView.rx.modelSelected(Bucket3Item.self)
            .subscribe(with: self) { owner, item in
                print("선택된 항목:", item.title)
            }.disposed(by: disposeBag)
        
        // itemSelected 처리
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                print("선택된 항목의 indexPath:", indexPath)
            }.disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        collectionView.backgroundColor = .lightGray
        collectionView.register(Buket3CollectionViewCell.self, forCellWithReuseIdentifier: Buket3CollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(Bucket3TableViewCell.self, forCellReuseIdentifier: Bucket3TableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
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
            }.disposed(by: disposeBag)
        
        return button
    }
    
    private func toggleFavorite(at index: Int) {
        var currentItems = viewModel.items.value
        currentItems[index].isFavorite.toggle()
        viewModel.items.accept(currentItems)
        viewModel.filteredItems.accept(currentItems)
    }
    
    func toggleChecked(at index: Int) {
        var currentItems = viewModel.items.value
        currentItems[index].isChecked.toggle()
        viewModel.items.accept(currentItems)
        viewModel.filteredItems.accept(currentItems)
    }
}


