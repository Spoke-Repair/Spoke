//
//  BikeListHome.swift
//  
//
//  Created by Garrett Huff on 11/19/17.

import UIKit
import Parse

var bikeList = [String]()
var customerBikeIDList = [String]()
var customerIndex: Int = 0;
var bikeObjectList = [PFObject]()

class BikeListHome: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var indicator = UIActivityIndicatorView()
    @IBOutlet var bikeCollectionView: UICollectionView!
    @IBOutlet var visitBlogButton: UIButton!

    @IBAction func visitBlogButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.spokerepair.com")!)
    }

    private func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bikeObjectList.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BikeCollectionCell", for: indexPath) as! BikeCollectionCell
        cell.textLabel.text = bikeObjectList[indexPath.row]["make"] as? String
        //set the color
        switch((indexPath.row) % 4) {
        
        case 1:
                print("CASE 1")
                cell.contentView.backgroundColor = UIColor(displayP3Red: 237/255, green: 248/255, blue: 245/255, alpha: 1.0)

        case 2:
                print("CASE 2")
                cell.contentView.backgroundColor = UIColor(displayP3Red: 255/255, green: 243/255, blue: 244/255, alpha: 1.0)

        case 3:
                print("CASE 3")
                cell.contentView.backgroundColor = UIColor(displayP3Red: 253/255, green: 251/255, blue: 245/255, alpha: 1.0)

        default:
                print("CASE default")
                cell.contentView.backgroundColor = UIColor(displayP3Red: 237/255, green: 248/255, blue: 245/255, alpha: 1.0)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customerIndex = indexPath.row
        self.performSegue(withIdentifier: "customerViewBike", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonUtils.addFCMTokenToParse()
        activityIndicator()
        visitBlogButton.layer.cornerRadius = 7
        visitBlogButton.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        //disable touch while the tableview is loading
        self.view.isUserInteractionEnabled = false

        bikeObjectList.removeAll()

        let query = PFQuery(className: "Bike")
        if let userID = PFUser.current()?.objectId {
            print("user ID: " + userID)
            query.whereKey("userID", equalTo: userID)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let bikeToAdd = object

                            if let picture = object["picture"] {
                                let pImage = picture as! PFFile
                                pImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                                    if let imageToSet = UIImage(data: data!) {
                                        bikeToAdd["picture"] = imageToSet
                                        print("Got image")
                                       // self.tableView.reloadData()
                                        self.bikeCollectionView.reloadData()
                                    }
                                })
                            }
                            if(!(bikeList.contains(object["model"] as! String))){
                                bikeList.append(object["model"] as! String)
                                customerBikeIDList.append(object.objectId!)
                            }
                            bikeObjectList.append(bikeToAdd)
                            print("ADDED BIKE TO LIST")
                        }
                        //reloadData()
                        self.bikeCollectionView.reloadData()
                        self.view.isUserInteractionEnabled = true
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                    }
                }
                else {
                    print("There was an error...")
                }
            })
        }
    }
}
