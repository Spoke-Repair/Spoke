//
//  CustomerOrStoreSelectionView.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 2/6/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class CustomerOrStoreSelectionView: UIView {

    @IBOutlet var view: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: "CustomerOrStoreSelectionView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

}
