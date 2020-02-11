//
//  ChatPageInfo.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit


class customTableCell: UITableViewCell{
    
    let profileImageView: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let callButton: UIButton = {
        let image = UIImage(named: "call")
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let messageButton: UIButton = {
        let image = UIImage(named: "message")
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let userNameLabel: UILabel = {
        let text = UILabel()
        text.text = "mama"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let activityLabel: UILabel = {
        let text = UILabel()
        text.text = "mama"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cellId")
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(messageButton)
        addSubview(callButton)
        addSubview(activityLabel)
        addConstraints()
    }
    
    
    func addConstraints(){
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        activityLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        activityLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        
        messageButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        messageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        callButton.rightAnchor.constraint(equalTo: messageButton.leftAnchor, constant: -15).isActive = true
        callButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        callButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

