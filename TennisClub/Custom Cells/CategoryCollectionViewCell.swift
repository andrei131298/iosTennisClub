//
//  CategoryCollectionViewCell.swift
//  TennisClub
//
//  Created by user191625 on 3/26/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func generateCell(_ category: Category){
        nameLabel.text = category.name
        imageView.image = category.image
        
    }
}
