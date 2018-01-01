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
    var newBike: PFObject!
    var segueFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating session
        let session = AVCaptureSession()
        //Define capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            CommonUtils.popUpAlert(message: "Unable to access camera", sender: self)
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch {
            print ("ERROR")
        }

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        let video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: square)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0, let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, object.type == AVMetadataObject.ObjectType.qr {
            newBike["bikeID"] = object.stringValue
            if(segueFlag == 0){
                segueFlag = 1
                self.performSegue(withIdentifier: "takePhotoSegue", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takePhotoSegue", let photoBikeVC = segue.destination as? PhotoOfBikeController {
            photoBikeVC.newBike = self.newBike
        }
    }
}
