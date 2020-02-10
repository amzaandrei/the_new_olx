//
//  pageTableCell.swift
//  coolAnimation
//
//  Created by Andrew on 10/7/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class pageTableCell: UITableViewCell{
    
    let cellId = "cellId"
    
    @objc let textLabelName: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    @objc let detailedLabelName: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    
    @objc let profileImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellId)
        
        addSubview(textLabelName)
        addSubview(detailedLabelName)
        addSubview(profileImage)
        addConstraints()
        
    }
    
    func addConstraints(){
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        textLabelName.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        textLabelName.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        textLabelName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        textLabelName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        detailedLabelName.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        detailedLabelName.topAnchor.constraint(equalTo: (textLabel?.bottomAnchor)!, constant: 3).isActive = true
        detailedLabelName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        detailedLabelName.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
