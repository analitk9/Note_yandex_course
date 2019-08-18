//
//  GalleryCell.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 23/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//
import UIKit
class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
}
