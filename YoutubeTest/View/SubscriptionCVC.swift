//
//  SubscriptionCVC.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 27.11.2019.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class SubscriptionCVC: FeedCVC {
    
    override func fetchVideous() {
        APIService.shared.fetchSubscription { [weak self] newVideos in
            guard let self = self else { return }
            self.videos = newVideos
            self.collectionView.reloadData()
        }
    }
}
