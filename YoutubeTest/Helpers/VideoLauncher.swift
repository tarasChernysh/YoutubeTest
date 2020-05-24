//
//  VideoLauncher.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 27.11.2019.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let acrivity = UIActivityIndicatorView(style: .whiteLarge)
        acrivity.translatesAutoresizingMaskIntoConstraints = false
        acrivity.startAnimating()
        return acrivity
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let pausePlayButton: UIButton = {
        let image = UIImage(named: "pause")
        let btn = UIButton(type: .system)
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        // need to set white colot for image
        btn.tintColor = .white
        btn.isHidden = true
        btn.addTarget(self, action: #selector(handleTappedPauseButton), for: .touchUpInside)
        return btn
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "00:00"
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        return slider
    }()
    
    var isPlaying = false
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupPlayer()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: 8).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleValueChanged() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { isCompleted in
                print("seek")
            })
        }
    }
    
    @objc func handleTappedPauseButton() {
        let image = isPlaying ? UIImage(named: "play"): UIImage(named: "pause")
        pausePlayButton.setImage(image, for: .normal)
        isPlaying ? player?.pause(): player?.play()
        
        isPlaying.toggle()
    }
    
    private func setupPlayer() {
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726") {
            
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            layer.addSublayer(playerLayer)
            playerLayer.frame = frame
            player?.play()
            // check if video ready
            // then need implement 'observeValue(forKeyPath keyPath: String?,...'
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            // track player observer
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] progressTime in
                guard let self = self else { return }
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                    
                }
            })
        }
    }
    
    private func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradient)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            print("ready")
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                    let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds.truncatingRemainder(dividingBy: 60))
                let minutesYext = Int(seconds) / 60
                videoLengthLabel.text = "\(minutesYext):\(secondsText)"
            }
        }
    }
}


class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            // 16*9 is a aspect ration of all HD videos
            let h = keyWindow.frame.width * 9 / 16
            let playerVideoFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: h)
            let videoPlayerView = VideoPlayerView(frame: playerVideoFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { completed in
                
            }
        }
    }
}
