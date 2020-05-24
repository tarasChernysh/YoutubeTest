//
//  VideoCell.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/10/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit


class VideoCell: BaseCollectionViewCell {
    enum C {
        static let left: CGFloat = 16
        static let right: CGFloat = 16
        static let betweenProfileImageAndTitleLabel: CGFloat = 8
        static let profileImage: CGFloat = 44
    }
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            let chanelName = video?.channel?.name ?? ""
            let numberViews = video?.number_of_views ?? 0
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let subtitleText = "\(chanelName) * \(numberFormatter.string(from: numberViews) ?? "") * 2 years ago"
            subtitleTextView.text = subtitleText
            
            if let title = video?.title {
                
                // needs to define allowed frame for label
                let size = CGSize(width: frame.width - C.betweenProfileImageAndTitleLabel - C.left - C.right - C.profileImage, height: 1000)
                let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimetedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: attr, context: nil)
                
                if estimetedRect.height > 20 {
                    titleLablHeightConstraint?.constant = 44
                } else {
                    titleLablHeightConstraint?.constant = 20
                }
            }
            downloadImage()
            downloadProfileImage()
        }
    }
    
    let thubnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFill
        /// it needs to clip image view
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mister Cat"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Mister Cat blasasdsdas asadasdasdasdadadadadada"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        return textView
    }()
    
    var titleLablHeightConstraint: NSLayoutConstraint?
    
    override func setupSubViews() {
        super.setupSubViews()
        addSubview(thubnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        /// horizontal
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thubnailImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView) // width to picture
        
        
        /// vertical
        /// '44', '1' - height
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thubnailImageView, userProfileImageView, separatorView)
        
        // title label
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thubnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: userProfileImageView, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: thubnailImageView, attribute: .trailing, multiplier: 1, constant: 0))
        titleLablHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLablHeightConstraint!)
        
        // subtittle text view
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .leading, relatedBy: .equal, toItem: userProfileImageView, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .trailing, relatedBy: .equal, toItem: thubnailImageView, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
    
    func downloadImage() {
        if let path = video?.thumbnail_image_name {
           self.thubnailImageView.downloadImage(withPath: path)
        }
    }
    
    func downloadProfileImage() {
        if let path = video?.channel?.profile_image_name {
            self.userProfileImageView.downloadImage(withPath: path)
        }
    }
}
