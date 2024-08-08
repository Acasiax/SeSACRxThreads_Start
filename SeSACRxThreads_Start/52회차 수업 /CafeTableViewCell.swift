//
//  CafeTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import SnapKit

final class CafeTableViewCell: UITableViewCell {
  //  static let identifier = "CafeTableViewCell"
    
    let menuNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let menuIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("주문", for: .normal)
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
           contentView.addSubview(menuNameLabel)
           contentView.addSubview(menuIconImageView)
           contentView.addSubview(orderButton)
           
           menuIconImageView.snp.makeConstraints { make in
               make.centerY.equalToSuperview()
               make.leading.equalTo(20)
               make.size.equalTo(60)
           }
           
           menuNameLabel.snp.makeConstraints { make in
               make.centerY.equalTo(menuIconImageView)
               make.leading.equalTo(menuIconImageView.snp.trailing).offset(8)
               make.trailing.equalTo(orderButton.snp.leading).offset(-8)
           }
           
           orderButton.snp.makeConstraints { make in
               make.centerY.equalTo(menuIconImageView)
               make.trailing.equalToSuperview().inset(20)
               make.height.equalTo(32)
               make.width.equalTo(72)
           }
    }
}
