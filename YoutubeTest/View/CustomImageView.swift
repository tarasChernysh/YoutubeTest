//
//  CustomImageView.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/11/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

/// щоб повторно не завантажувати з нету картинки які вже завантажені
/// треба створити кеш

let cashe = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
   
    func downloadImage(withPath path: String) {
        guard let url = URL(string: path) else { return }
        
        /// при швидкому скролі картинки підгружаються в таблицю не відповідні
        /// тому треба зробити наступне:
        imageUrlString = path
        image = nil
        if let imageFromCache = cashe.object(forKey: path as NSString) {
            image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                
                /// для того щоб при швидкому скролі підгружалися відповідні картинки
                /// в ячейки
                if self.imageUrlString == path {
                    self.image = imageToCache
                }
                
                cashe.setObject(imageToCache!, forKey: path as NSString)
            }
            }.resume()
        
    }
}

