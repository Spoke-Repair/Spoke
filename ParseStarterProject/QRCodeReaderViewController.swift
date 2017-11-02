//
//  QRCodeReaderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//
import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    var userID: String? = nil
    var segueFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
        
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    userID = object.stringValue
                    //let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    //alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    //alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    //  UIPasteboard.general.string = object.stringValue
                    //}))
                    
                    //present(alert, animated: true, completion: nil)
                    if(segueFlag == 0){
                        segueFlag = 1
                        self.performSegue(withIdentifier: "foundBikeSegue", sender: self)
                        
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
        if segue.identifier == "foundBikeSegue"{
            print("Im in prepare segue (found bike) and my ID is: "+userID!)
            /*
             if let openBikeVC = segue.destination as? FoundBikeViewController {
             openBikeVC.userId = userID
             }*/
            
            let navVC = segue.destination as? UINavigationController
            let vc = navVC?.viewControllers.first as! FoundBikeViewController
            vc.userId = userID
        }
        
        
    }
    
 
    
}
