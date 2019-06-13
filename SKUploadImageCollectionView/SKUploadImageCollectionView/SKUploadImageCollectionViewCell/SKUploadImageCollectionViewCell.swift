//
//  SKUploadImageCollectionViewCell.swift
//  SKUploadImageCollectionViewExample
//
//  Created by admin on 6/12/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class SKUploadImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomButtonImageView: UIImageView!
    @IBOutlet weak var bottomTitleLabel1: UILabel!
    @IBOutlet weak var bottomTitleLabel2: UILabel!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    //MARK: - IBAction
    @IBAction func didClickBottomButton() {
        
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true)
    {
        shadowView.layer.masksToBounds = true
        shadowView.clipsToBounds = true
        shadowView.layer.shadowColor = color.cgColor
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowOffset = offSet
        shadowView.layer.shadowRadius = radius
        shadowView.layer.cornerRadius = radius

        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = radius
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    
}
