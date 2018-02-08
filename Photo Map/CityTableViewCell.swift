//
//  CityTableViewCell.swift
//  Photo Map
//
//  Created by Nathan Hays on 2/8/18.
//  Copyright © 2018 Nathan Hays. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelCity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
