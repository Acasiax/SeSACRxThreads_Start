//
//  MyBoxVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyBoxVC: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let viewModel = MyBoxOfficeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        createObservable()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        collectionView.backgroundColor = .lightGray
        collectionView.register(MyMovieCollectionViewCell.self, forCellWithReuseIdentifier: MyMovieCollectionViewCell.identifier)
        
    }
    
    func createObservable() {
        
        //MARK: - Observable 생성
        let ramdom = Observable<Int>.create { value in
            
            let result = Int.random(in: 1...100)
            
            if result >= 1 && result <= 45 {
                value.onNext(result) // onNext(result)를 통해 해당 값을 방출
                
            } else {
                value.onCompleted() // 그 외의 값이면 onCompleted()를 호출하여 스트림을 완료
            }
            return Disposables.create() //Disposable을 반환하여 리소스 정리를 수행
        }
        
        //MARK: - Observable 구독:
        ramdom
            .subscribe(with: self) { owner, value in
                print("랜덤값 \(value)")
            } onCompleted: { value in
                print("Completed")
            } onDisposed: { value in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        
        let recentText = PublishSubject<String>()
        
        let input = MyBoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        let output = viewModel.transform(input: input)
        
        
        
    }
    
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
}
