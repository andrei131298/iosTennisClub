//
//  ImageCollectionViewCell.swift
//  TennisClub
//
//  Created by user191625 on 3/29/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage){
        imageView.image = itemImage
    }
}
