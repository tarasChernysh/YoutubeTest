//
//  AppDelegate.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/4/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.statusBarStyle = .lightContent
        createRootVC()
        setupNavBar()
        return true
    }
    
    private func createRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        let vc = NomeViewController(collectionViewLayout: layout)
        vc.view.backgroundColor = .green
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    private func setupNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        
        /// remove grid between navbar and menubar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .compactPrompt)
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)
        
        window?.addSubview(statusBarBackgroundView)
        
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
    }
}

