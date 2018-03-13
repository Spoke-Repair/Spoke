//
//  CustomerCheckoutVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 3/11/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Stripe
import Alamofire


extension CustomerCheckoutVC: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        
        completeCharge(with: token, amount: 6000) { result in
            switch result{
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats",
                                                        message: "Your payment was successful!",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
                
            }
        
        }
        
    
    }


class CustomerCheckoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result<Any>) -> Void) {
        // 1
        let baseURL = "http://ec2-34-228-22-70.compute-1.amazonaws.com:80/parse/functions/"
        let url = baseURL + "chargeCustomer"
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": "usd",
            "description": "Payment for Bike repair"
        ]
        
        let headers: HTTPHeaders = [
            "x-parse-application-id": "9756991d318b51864e3ae7a93f36efd4e4480f16",
            "content-type": "application/json"
        ]
        
        // 3
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success("Payment success!"))
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    


}
