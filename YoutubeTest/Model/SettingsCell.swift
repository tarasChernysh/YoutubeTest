//
//  File.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/11/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class SettingsCell: BaseCollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .darkGray
            imageView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var setting: SettingItem? {
        didSet {
            nameLabel.text = setting?.rawValue
            imageView.image = UIImage(named: setting?.iconName ?? "")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .darkGray
        }
    }
    
    override func setupSubViews() {
        super.setupSubViews()
        
        addSubview(nameLabel)
        addSubview(imageView)
        /// '(30)' - width
        /// first '8' - leading space; second '8' - space between nameLabel and imageView
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
