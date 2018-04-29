//
//  ImageCollectionViewCell.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/22/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        imageView.frame = UIScreen.main.bounds
//        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }
}
