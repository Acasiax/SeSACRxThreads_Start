//
//  Buket3CollectionViewCell.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import SnapKit

final class Buket3CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "Buket3CollectionViewCell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

