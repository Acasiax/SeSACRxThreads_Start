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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
}
