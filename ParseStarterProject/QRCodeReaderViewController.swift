//
//  QRCodeReaderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//
import UIKit
import AVFoundation
import Parse

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var square: UIImageView!
    var userID: String?
    var segueFlag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //Creating session
        let session = AVCaptureSession()

        //Define capture devcie
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
        guard metadataObjects.count != 0, let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, object.type == AVMetadataObject.ObjectType.qr else {
            CommonUtils.popUpAlert(message: "Could not scan code", sender: self)
            print("Error in metadataOutput")
            return
        }
        self.userID = object.stringValue
        let query = PFQuery(className: "Bike")
        query.whereKey("bikeID", equalTo: userID!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            guard error == nil && objects != nil else {
                CommonUtils.popUpAlert(message: "Could not retrieve Bike info", sender: self)
                print("Failed bike ID: \(self.userID!)")
                return
            }
            guard objects?[0]["isOwned"] as! Bool == true else {
                CommonUtils.popUpAlert(message: "Bike is not assigned to owner", sender: self)
                print("Unowned bike ID: \(self.userID!)")
                return
            }
            if self.segueFlag == 0 {
                self.segueFlag = 1
                self.performSegue(withIdentifier: "foundBikeSegue", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foundBikeSegue"{
            print("Im in prepare segue (found bike) and my ID is: " + userID!)
            let navVC = segue.destination as? UINavigationController
            let vc = navVC?.viewControllers.first as! FoundBikeViewController
            vc.userId = userID
        }
    }
}
