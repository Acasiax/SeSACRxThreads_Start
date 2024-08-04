//
//  SearchVC49Example.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    let searchBar = UISearchBar()
    
    var data = ["A", "B", "C", "AB", "D", "ABC"]
    lazy var items = BehaviorSubject(value: data)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green
                
                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "셀 선택 \($0) \($1)" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 검색 버튼이 클릭될 때마다 검색어를 받아 처리
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) // withLatestFrom: 검색 버튼이 클릭될 때 가장 최근의 검색어를 가져오는 거.
            .subscribe(with: self, onNext: { owner, text in
                owner.data.insert(text, at: 0) // 새로운 검색어를 데이터 목록의 맨 앞에 추가
                owner.items.onNext(owner.data) // 변경된 데이터를 items subject에 전달
            })
            .disposed(by: disposeBag)
        
        // 검색어 입력을 실시간으로 처리합니다.
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance) // debounce: 사용자가 입력을 멈춘 후 1초 동안 대기
            .distinctUntilChanged() // distinctUntilChanged: 이전 검색어와 다른 경우에만 이벤트를 발생하는 거임
            .subscribe(with: self) { owner, value in
                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value) } // 검색어를 포함하는 데이터 필터링
                owner.items.onNext(result) // 필터링된 데이터를 items subject에 전달
                print("==실시간 검색== \(value)")
            }
            .disposed(by: disposeBag)
    }
}

final class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다운로드", for: .normal)
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configure() {
        contentView.addSubview(appIconImageView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(appIconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        downloadButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}

class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
