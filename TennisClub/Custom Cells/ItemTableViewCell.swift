//
//  ItemTableViewCell.swift
//  TennisClub
//
//  Created by user191625 on 3/27/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func generateCell(_ item: Item){
        
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = "\(item.price!)"
        
        
    }

}
