//
//  FeedCell.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 24.11.2019.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class FeedCVC: BaseCollectionViewCell {
    enum C {
        static let left: CGFloat = 16
        static let right: CGFloat = 16
        static let top: CGFloat = 16
        static let bottom: CGFloat = 16
        static let profileHeight: CGFloat = 44
        static let paddingBetweenLabel: CGFloat = 8
        static let bottomLabel: CGFloat = 16
        static let reserve: CGFloat = 16
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let cellID = "videoCellID"
    var videos: [Video] = []
    
    override func setupSubViews() {
        super.setupSubViews()
        
        backgroundColor = .green
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellID)
        fetchVideous()
    }
    
    // MARK: - Fetch
    
    func fetchVideous() {
        APIService.shared.fetchVideous { [weak self] newVideos in
            guard let self = self else { return }
            self.videos = newVideos
            self.collectionView.reloadData()
        }
    }
}

extension FeedCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        cell.video = video
        return cell
    }
    
}

extension FeedCVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }
}

extension FeedCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - C.left - C.right) * 9 / 16
        return CGSize(width: frame.width, height: height + C.top + C.paddingBetweenLabel + C.profileHeight + C.bottomLabel + C.bottom + C.reserve)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
