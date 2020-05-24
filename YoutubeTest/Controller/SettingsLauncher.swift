//
//  SettingsLauncher.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/11/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

enum SettingItem: String, CaseIterable {
    case settings = "Settings"
    case term = "Terms and privacy policy"
    case feedback = "Send feedback"
    case help = "Help"
    case switchAccount = "Switch account"
    case cancel = "Cancel"
    
    var iconName: String {
        switch self {
        case .settings:
            return "settings"
        case .cancel:
            return "cancel"
        case .term:
            return "privacy"
        case .help:
            return "help"
        case .feedback:
            return "feedback"
        case .switchAccount:
            return "switch_account"
        }
    }
}

class SettingsLauncher: NSObject {
    
    private let balckView = UIView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let cellID = "cellID"
    private let cellHeight: CGFloat = 50
    
    let settings = SettingItem.allCases
    
    var homeVC: NomeViewController?
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            balckView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(balckView)
            window.addSubview(collectionView)
            
            let height: CGFloat = cellHeight * CGFloat(settings.count)
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            balckView.frame = window.frame
            balckView.alpha = 0
            
            balckView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.balckView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            
        }
    }
    
    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.balckView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
}

extension SettingsLauncher: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SettingsCell
        cell.setting = settings[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.balckView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { isComplated in
            let setting = self.settings[indexPath.row]
            if setting != SettingItem.cancel {
                self.homeVC?.showDummyVC(with: setting)
            }
        }
    }
}

extension SettingsLauncher: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    /// space bettween item by vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
