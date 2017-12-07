//
//  PhotoOfBikeController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 11/5/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PhotoOfBikeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var userId: String? = nil
    var bikeId: String? = nil
    var make: String? = nil
    var model: String? = nil
    var type: String? = nil
    var picture: UIImage? = nil
    
    var buttonToggle = false
    
    @IBOutlet var imagePicked: UIImageView!
    @IBOutlet var continueButton: UIButton!
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func continueButton(_ sender: Any) {
    //save in parse and segue
        
        if(buttonToggle == false){
        
            openCamera()
        
        }else{
            
            self.performSegue(withIdentifier: "confirmBike", sender: self)

        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.picture = image
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
        buttonToggle = true
        continueButton.contentHorizontalAlignment = .center
        continueButton.titleLabel?.text = "Continue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmBike"{
            
            if let confirmBikeVC = segue.destination as? ConfirmBikeVC {
                confirmBikeVC.userId = PFUser.current()?.objectId
                confirmBikeVC.bikeId = bikeId
                confirmBikeVC.make = make
                confirmBikeVC.model = model
                confirmBikeVC.type = type
                confirmBikeVC.pictureOfBike = picture
            }
            
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
