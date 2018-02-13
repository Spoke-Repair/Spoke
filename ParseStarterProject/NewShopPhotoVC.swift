//
//  NewShopPhotoVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/7/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class NewShopPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: PFUser!
    var buttonToggle = false
    @IBOutlet var imagePicked: UIImageView!
    @IBOutlet var continueButton: UIButton!
    
    private func openCamera() {
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
            self.performSegue(withIdentifier: "newShopPasswordSegue", sender: self)
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
        if segue.identifier == "newShopPasswordSegue", let nextVC = segue.destination as? NewShopPasswordVC {
            let imageData = UIImageJPEGRepresentation(self.imagePicked.image!, 0.1)
            let pimageFile = PFFile(data: imageData!)
            user["profile_pic"] = pimageFile
            nextVC.user = self.user
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "confirmBike", let confirmBikeVC = segue.destination as? ConfirmBikeVC {
//            let imageData = UIImageJPEGRepresentation(self.imagePicked.image!, 0.1)
//            let pimageFile = PFFile(data: imageData!)
//            newBike["picture"] = pimageFile
//            confirmBikeVC.newBike = newBike
//            confirmBikeVC.bikePicture = self.imagePicked.image!
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
