//
//  AvailableServiceCell.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class AvailableServiceCell: UITableViewCell {
    @IBOutlet var serviceName: UILabel!

    @IBOutlet var servicePrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
