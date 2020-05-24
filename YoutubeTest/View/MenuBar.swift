//
//  MenuBar.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/10/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cw.dataSource = self
        cw.delegate = self
        return cw
    }()
    
    let cellID = "menuCellID"
    private let imageNames = ["home", "trending", "subscriptions", "account"]
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var homeVC: NomeViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        ///needs to select and highlight 'Home' menu button when you first time launch the app
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .bottom)
        
        setupHorizontalBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHorizontalBar() {
        let horizontalView = UIView()
        horizontalView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalView)
        // needs x, y, w, h
        horizontalBarLeftAnchorConstraint = horizontalView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        horizontalView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4, constant: 0).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
}

// MARK: - UICollectionViewDataSource

extension MenuBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        /// needs to chancge tint color into image
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// for move line indicator into mnu bar view
//        let x = CGFloat(indexPath.row) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }) { isCompleted in
//
//        }
        homeVC?.scrollToMenuIndex(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    /// space between item (horizontal)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
