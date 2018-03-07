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
    @IBOutlet var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        self.user["profile_pic"] = PFFile(data: UIImageJPEGRepresentation(image, 0.1)!)
        proceed()
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        camera()
    }
    
    @IBAction func skipPhoto(_ sender: UIBarButtonItem) {
        self.user.remove(forKey: "profile_pic")
        proceed()
    }
    
    private func camera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            CommonUtils.popUpAlert(message: "Camera is unavailable", sender: self)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func proceed() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "NewShopPasswordVC") as! NewShopPasswordVC
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
