//
//  MenuCell.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/10/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class MenuCell: BaseCollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "home")
        /// needs to change tint color in image
        image?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? .white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? .white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupSubViews() {
        super.setupSubViews()
        
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
