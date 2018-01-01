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

    var newBike: PFObject!
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
        if (buttonToggle == false){
            openCamera()
        }
        else {
            self.performSegue(withIdentifier: "confirmBike", sender: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
        buttonToggle = true
        continueButton.contentHorizontalAlignment = .center
        continueButton.titleLabel?.text = "Continue"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmBike", let confirmBikeVC = segue.destination as? ConfirmBikeVC {
            let imageData = UIImageJPEGRepresentation(self.imagePicked.image!, 0.1)
            let pimageFile = PFFile(data: imageData!)
            newBike["picture"] = pimageFile
            confirmBikeVC.newBike = newBike
            confirmBikeVC.bikePicture = self.imagePicked.image!
        }
    }
}
