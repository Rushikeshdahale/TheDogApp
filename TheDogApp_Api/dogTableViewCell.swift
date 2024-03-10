//
//  dogTableViewCell.swift
//  TheDogApp_Api
//
//  Created by Rushikesh Dahale on 10/03/24.
//

import UIKit

class dogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var dogNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
