//
//  APIService.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 24.11.2019.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

class APIService: NSObject {
    
    static let shared = APIService()
    
    func fetchVideous(completion: @escaping ([Video]) -> ()) {
        fetchFeedForURLString(path: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json", completion: completion)
    }
    
    func fetchTrendingVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForURLString(path: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json", completion: completion)
    }
    
    func fetchFeedForURLString(path: String, completion: @escaping ([Video]) -> ()) {
        guard let url = URL(string: path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error ?? "")
                return
            }
            guard let data = data else { return }
            var videos: [Video] = []
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                guard let values = json as? [[String: AnyObject]] else { return }
                
                for dict in values {
                    let video = Video()
                    video.title = dict["title"] as? String
                    video.number_of_views = dict["number_of_views"] as? NSNumber
                    video.thumbnail_image_name = dict["thumbnail_image_name"] as? String
                    
                    let chanel = Chanel()
                    let chanelDict = dict["channel"] as? [String: AnyObject]
                    chanel.name = chanelDict?["name"] as? String
                    chanel.profile_image_name = chanelDict?["profile_image_name"] as? String
                    video.channel = chanel
                    videos.append(video)
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch let newError {
                print(newError)
            }
        }.resume()
    }
    
    func fetchSubscription(completion: @escaping ([Video]) -> ()) {
        fetchFeedForURLString(path: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json", completion: completion)
    }
}
