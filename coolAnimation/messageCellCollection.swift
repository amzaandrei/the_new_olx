//
//  messageCellCollection.swift
//  coolAnimation
//
//  Created by Andrew on 7/17/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import AVFoundation

class messageCell: UICollectionViewCell{
    
    
    @objc var message: messages?
    
    @objc var chatLogController: pageChat?
    
    @objc let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        
        return tv
    }()
    
    @objc static let bubbleColor = UIColor.blue
    
    @objc let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = bubbleColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    @objc let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @objc let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    @objc lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "hustle")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    @objc let indicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    @objc var bubbleWidthAnchor: NSLayoutConstraint?
    @objc var bubbleViewRightAnchor: NSLayoutConstraint?
    @objc var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    @objc var playerLayer: AVPlayerLayer?
    @objc var player: AVPlayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        //        bubbleViewLeftAnchor?.active = false
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
        
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
//    func handlePlayButton(){
//        if let url = message?.videoUrl{
//            let actualURl = URL(string: url)
//            player = AVPlayer(url: actualURl!)
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = bubbleView.bounds
//            bubbleView.layer.addSublayer(playerLayer!)
//            player?.play()
//            indicator.startAnimating()
//            playButton.isHidden = true
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        playerLayer?.removeFromSuperlayer()
//        player?.pause()
//        indicator.stopAnimating()
//    }
    
    @objc func imageTapped(tap: UITapGestureRecognizer){
        if message?.videoUrl != nil{
            let videoView = tap.view as? UIImageView
            self.chatLogController?.performZoomImage(startingImageView: videoView!,videoUrl: message?.videoUrl)
            return
        }
        let imageView = tap.view as? UIImageView
        self.chatLogController?.performZoomImage(startingImageView: imageView!,videoUrl: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
