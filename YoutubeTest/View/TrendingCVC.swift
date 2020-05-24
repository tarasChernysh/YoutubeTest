//
//  TrendingCVC.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 24.11.2019.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class TrendingCVC: FeedCVC {
    
    override func fetchVideous() {
        APIService.shared.fetchTrendingVideos { [weak self] newVideos in
            guard let self = self else { return }
            self.videos = newVideos
            self.collectionView.reloadData()
        }
    }
}
