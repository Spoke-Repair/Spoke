//
//  ShopInventoryVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/21/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class ShopInventoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfItemsInSelection: Int) -> Int {
        return 5 //Arbitrary number to test
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ShopInventoryCell", for: indexPath) as! ShopInventoryCell
        return cell
    }
}
