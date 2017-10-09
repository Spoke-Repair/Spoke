//
//  CustomerViewCusMessageCell.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class CustomerViewCusMessageCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
