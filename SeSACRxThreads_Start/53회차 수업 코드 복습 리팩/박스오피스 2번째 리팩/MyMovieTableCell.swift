//
//  MyMovieTableCell.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyMovieTableViewCell: UITableViewCell {
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = 8
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appIconImageView)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-8)
            
        }
        
        
        downloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(appIconImageView)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
            make.width.equalTo(72)
            
        }
    }
}
    
