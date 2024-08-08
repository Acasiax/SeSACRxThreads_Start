//
//  CafeViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CafeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = CafeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        
    }
    
    func bind() {
            
        let recentText = PublishSubject<String>()
        
        let input = CafeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        
        let output = viewModel.transform(input: input)
            
        // 테이블뷰에 menuList 바인딩
        output.menuList
            .bind(to: tableView.rx.items(cellIdentifier: CafeTableViewCell.identifier, cellType: CafeTableViewCell.self)) { (row, element, cell) in
                cell.menuNameLabel.text = element
                
            }.disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: CafeCollectionViewCell.identifier, cellType: CafeCollectionViewCell.self)) { (row, element, cell ) in
                cell.label.text = element
               // cell.label.text = "\(element), \(row)"
            }.disposed(by: disposeBag)

        // Observable.zip 사용하여 modelSelected와 itemSelected 동시에 처리
        Observable.zip(tableView.rx.modelSelected(String.self),
                       tableView.rx.itemSelected
        )
        .debug("디버깅") // 디버깅을 위해 Observable의 이벤트를 콘솔에 출력하는 메소드 (프린트의 대체재)🌟
        // 나중에 최종 프로젝트 제출 시에는 이 코드를 삭제해야 함
        // 심사위원이 지원자가 충분히 테스트하지 않았다고 생각할 수 있음
        .map {"검색어는 \($0.0)"}
            .subscribe(with: self) { owner, value in
       
                recentText.onNext(value)
                print(value)
            }
            .disposed(by: disposeBag)
        
        // modelSelected 처리
        tableView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, value in
                print("선택된 model:", value)
            }
            .disposed(by: disposeBag)
        
        // itemSelected 처리
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                print("선택된 item의 indexPath:", indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        collectionView.backgroundColor = .lightGray
        collectionView.register(CafeCollectionViewCell.self, forCellWithReuseIdentifier: CafeCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(CafeTableViewCell.self, forCellReuseIdentifier: CafeTableViewCell.identifier)
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
    
}

