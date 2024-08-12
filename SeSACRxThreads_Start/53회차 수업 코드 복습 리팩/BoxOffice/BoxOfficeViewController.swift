//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = BoxOfficeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        
        
        
//        NetworkManager.shared.callBoxOffice(date: )
//            .subscribe { value in
//                print("Next event \(value)")
//            } onError: { error in
//                print("error - \(error)")
//            } onCompleted: {
//                print("completed") //=> disposed가 되더라~!
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposeBag)
//        
        
        
        
        createObservable()
        
    }
    // Observable Create 연습.
    // create
    //47회차 Obervable LifeCycle
    func createObservable() {
        let random = Observable<Int>.create { value in
            
            let result = Int.random(in: 1...100)
            
            if result >= 1 && result <= 45 {
                value.onNext(result) // onNext(result)를 통해 해당 값을 방출
            } else {
                value.onCompleted()
         
               // value.onError()
            }
            return Disposables.create()
        }
        
        random
            .subscribe(with: self) {owner, value in
                print("ramdom: \(value)")
            } onCompleted: { value in
                print("Completed")
            } onDisposed: { value in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
          //  .dispose
    }
    
    
    
    func bind() {
        
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        
        let output = viewModel.transform(input: input)
        

        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell ) in
                cell.label.text = element
                // cell.label.text = "\(element), \(row)"
            }.disposed(by: disposeBag)
        
        // - 테이블뷰셀 클릭 => 데이터 가져오기 => 검색어는 테스트2 라는 형태로 문자열 => 컬렉션뷰 데이터로 전달
        // -> vm.recentList.append -> output을 통해 collectionView에 반영
        // - modelSelected > Data
        // - itemSelected > IndexPath
        
        
        // 테이블뷰에 movieList 바인딩
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element.movieNm
                cell.downloadButton.setTitle(element.openDt, for: .normal)
                //  cell.label.text = "\(element), \(row)"
                
            }.disposed(by: disposeBag)
        
        // Observable.zip 사용하여 modelSelected와 itemSelected 동시에 처리
        Observable.zip(tableView.rx.modelSelected(String.self),
                       tableView.rx.itemSelected
        )
        .debug("잭잭잭 박") // 디버깅을 위해 Observable의 이벤트를 콘솔에 출력하는 메소드 (프린트의 대체재)🌟
        // 나중에 최종 프로젝트 제출 시에는 이 코드를 삭제해야 함
        // 심사위원이 지원자가 충분히 테스트하지 않았다고 생각할 수 있음
        // 몇 번째줄 어떤 명령을 수행했는지 구체적으로 확인 가능, print의 대체재, identifier도 넣을 수 있음
        .map {"검색어는 \($0.0)"}
        .subscribe(with: self) { owner, value in
            // 여기서 input으로 데이터를 보내줘야돼 어떻게?
            // - 큰데에서 작은데로 들어가는건 쉬우니까 변수로 선언해두고 그 변수를 바꿔주자!
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
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
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
