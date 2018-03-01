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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            CommonUtils.popUpAlert(message: "Camera is not available!", sender: self)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func skipPhoto(_ sender: UIBarButtonItem) {
        self.newBike.remove(forKey: "picture")
        proceed(nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        newBike["picture"] = PFFile(data: UIImageJPEGRepresentation(image, 0.1)!)
        proceed(image)
    }
    
    private func proceed(_ image: UIImage?) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmBikeVC") as! ConfirmBikeVC
        vc.newBike = self.newBike
        vc.bikePicture = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
