//
//  AddBikeScannerVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import Parse


class AddBikeScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    var bikeID: String? = nil
    var segueFlag = 0
    
    var make: String? = nil
    var model: String? = nil
    var type: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
        
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    bikeID = object.stringValue
                    //let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    //alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    //alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    //  UIPasteboard.general.string = object.stringValue
                    //}))
                    
                    //present(alert, animated: true, completion: nil)
                    if(segueFlag == 0){
                        segueFlag = 1
                        self.performSegue(withIdentifier: "confirmBike", sender: self)
                        
                    }
                    //let vc = FoundBikeViewController()
                    //vc.userId = userID
                    //self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmBike"{
            
             if let confirmBikeVC = segue.destination as? ConfirmBikeVC {
                confirmBikeVC.userId = PFUser.current()?.objectId
                confirmBikeVC.bikeId = bikeID
                confirmBikeVC.make = make
                confirmBikeVC.model = model
                confirmBikeVC.type = type
                
             }
            
            
        }
        
        
    }

}
