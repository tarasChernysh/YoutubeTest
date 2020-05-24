//
//  ViewController.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/4/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class NomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    enum C {
        static let menuBarHeight: CGFloat = 50
    }
    private lazy var settingLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeVC = self
        return launcher
    }()
    private let cellID = "cell"
    private let trendingCellID = "trendingCellID"
    private let subscriptionCellID = "subscriptionCellID"
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.homeVC = self
        return mb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupNavigationBar()
        setupMenuBar()
        setupCollectionView()
        setupNavBarButtons()
    }
    
    // MARK: - Selectors
    
    @objc func didTappedSearchBarButtonItem() {
        print("")
    }
    
    @objc func didTappedMoreBarButtonItem() {
        settingLauncher.showSettings()
    }
    
    // MARK: - Setups
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(didTappedSearchBarButtonItem))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(didTappedMoreBarButtonItem))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem ,searchBarButtonItem]
    }
    
    private func setupCollectionView() {
        self.collectionView?.backgroundColor = .white
        collectionView.register(TrendingCVC.self, forCellWithReuseIdentifier: trendingCellID)
        collectionView.register(FeedCVC.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(SubscriptionCVC.self, forCellWithReuseIdentifier: subscriptionCellID)
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        layout.minimumLineSpacing = 0
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format:"H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format:"V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.textColor = .white
        titleLabel.text = "  Home"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }
    
    func showDummyVC(with setting: SettingItem) {
        let dummyVC = UIViewController()
        dummyVC.view.backgroundColor = .white
        dummyVC.navigationItem.title = setting.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(dummyVC, animated: true)
    }
    
    private func setTitleForIndex(_ index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  " + titles[Int(index)]
        }
    }
    
    /// need fot move indicator view into screen
    func scrollToMenuIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setTitleForIndex(index)
    }
    
    // MARK: - Data Source
    
    /// need to figure out position when scroll is ended to highlithed item in menu bar
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(row: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        setTitleForIndex(Int(index))
    }
    
    /// always call when scroll happened
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = ""
        
        if indexPath.row == 1 {
            identifier = trendingCellID
        } else if indexPath.row == 2 {
            identifier = subscriptionCellID
        } else {
            identifier = cellID
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - C.menuBarHeight)
    }
}



