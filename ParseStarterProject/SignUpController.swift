import UIKit
import Parse

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    var phoneNumberEntered = false
    var phoneNumber = ""
    var password:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.height - 100))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.width))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.view.frame.height))
        path.close()
        
        let triangle = CAShapeLayer()
        triangle.path = path.cgPath
        triangle.fillColor = UIColor(red:0.79, green:0.93, blue:0.98, alpha:1.0).cgColor
        self.view.layer.addSublayer(triangle)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        var newString = ""
        
        //alternative route if char was deleted from password field
        if(newLength < (textField.text?.count)! && phoneNumberEntered == true) {
            textField.text!.removeLast()
            return false
        }
        
        //alternative logic to see if character was deleted
        if(newLength < (textField.text?.count)! && phoneNumberEntered == false) {
            
            //(210) - 4
            if(newLength == 8){
                print("Should remove spaces dash and parenthesis")
                textField.text = textField.text!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                textField.text = textField.text!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                textField.text = textField.text!.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
                
            }
            
            //(210) - 432 -
            //length 14
            if(newLength == 14) {
                newString = textField.text!
                newString.removeLast()
                newString.removeLast()
                newString.removeLast()
                textField.text = newString
            }
            if(newLength == 13) {
                newString = textField.text!
                newString.removeLast()
                newString.removeLast()
                textField.text = newString
            }
            return true
        }
        if(phoneNumberEntered == false){
            if(newLength == 1){
                textField.text! += "("
            }
            if(newLength == 4) {
                newString = textField.text! + string + ") - "
                textField.text = newString
                return false
            }
            if(newLength == 5){
                newString = textField.text! + ") - " + string
                textField.text = newString
                return false
            }
            if(newLength == 11) {
                
                newString = textField.text! + string + " - "
                textField.text = newString
                return false
            }
            if(newLength == 12) {
                newString = textField.text! + " - " + string
                textField.text = newString
                return false
            }
            if(newLength == 18) {
                textField.text = textField.text! + string
                UIView.animate(withDuration: 1, animations: {
                    
                    self.phoneNumber = textField.text!
                    self.phoneNumberEntered = true
                    textField.placeholder = "Enter a password"
                    textField.text = ""
                    
                    //create button for end of text input
                    let button = UIButton(type: .custom)
                    button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
                    button.imageEdgeInsets = UIEdgeInsetsMake(2, -16, 2, 10)
                    button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
                    button.addTarget(self, action: #selector(self.enteredFirstPassword), for: .touchUpInside)
                    self.instructionLabel.text = "Enter your password"
                    textField.rightView = button
                    textField.keyboardType = UIKeyboardType.default
                    textField.isSecureTextEntry = true
                    textField.rightViewMode = .always
                    
                    textField.center.x += self.view.bounds.width
                }, completion: nil)
                
                return false
            }
        } else {
            textField.text = textField.text! + string
            self.password = textField.text!
            return false
        }
        
        return true
    }
    
    @objc func enteredFirstPassword() {
        guard !(self.textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter a password", sender: self)
            return
        }
        UIView.animate(withDuration: 1, animations: {
            self.password = self.textField.text!
            self.textField.text = ""
            self.textField.placeholder = "Re-enter password"
            
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(2, -16, 2, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
            self.instructionLabel.text = "Now re-enter your password"
            self.textField.rightView = button
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.isSecureTextEntry = true
            self.textField.rightViewMode = .always
            
            self.textField.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
    @objc func login() {
        guard !(self.textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter a password", sender: self)
            return
        }
        print("Second password entered")
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    

//    @IBOutlet weak var prompt: UILabel!
//    @IBOutlet weak var errorLabel: UILabel!
//    @IBOutlet weak var input: UITextField!
//
//    private var loginErrorMsg: String?
//    private var currentPage = 0
//    private let prompts = ["What's your email address?", "What's your first name?", "What's your last name?", "What's your password?", "Re-enter your password"]
//    private var userInfo: [String?] = [nil, nil, nil, nil, nil]
//
//    @IBAction func proceed(_ sender: UIButton) {
//        guard let userInput = input.text?.trimmingCharacters(in: .whitespacesAndNewlines), userInput.count > 0 && currentPage < prompts.count else {
//            errorLabel.isHidden = false
//            return
//        }
//        errorLabel.isHidden = true
//        userInfo[currentPage] = userInput
//        input.text = ""
//        currentPage += 1
//        if currentPage == prompts.count {
//
//            //Ensure that user typed password correctly
//            guard userInfo[3] == userInfo[4] else {
//                self.loginErrorMsg = "Failed - passwords must match for user"
//                self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
//                return
//            }
//
//            signUp(userInfo[0]!, userInfo[1]!, userInfo[2]!, userInfo[3]!)
//            return
//        }
//        else if currentPage == prompts.count - 1 {
//            sender.setTitle("Submit", for: .normal)
//        }
//
//        sender.isEnabled = false
//        UIView.animate(withDuration: 0.25, animations: {
//            self.prompt.alpha = 0.0
//        }, completion: {(true) in
//            self.prompt.center.x -= self.view.bounds.width
//            self.prompt.alpha = 1.0
//            self.prompt.text = self.prompts[self.currentPage]
//            UIView.animate(withDuration: 0.25, animations: {
//                self.view.layoutIfNeeded()
//                sender.isEnabled = true
//            })
//        })
//    }
//
//    private func signUp(_ email: String, _ first: String, _ last: String, _ pass: String) {
//        let user = PFUser()
//        user.username = email
//        user.password = pass
//        user["firstname"] = first
//        user["lastname"] = last
//        user["type"] = "customer"
//        user.signUpInBackground() { (success, error) in
//            if error != nil {
//                print("Failed to create account \(email)")
//                self.loginErrorMsg = error?.localizedDescription
//                self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
//                return
//            }
//            print("Created account \(email)")
//            user.saveInBackground(block: { (success: Bool, error: Error?) in
//                if(success){
//                    self.performSegue(withIdentifier: "signUpActivated", sender: self)
//                }
//            })
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let loginVC = segue.destination as? ViewController, let errMsg = self.loginErrorMsg else { return }
//        loginVC.errMsgStr = errMsg + ": " + (userInfo[0] ?? "")
//    }
//
//    @IBAction func cancelSignUpButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.prompt.text = self.prompts[self.currentPage]
//        self.input.underline()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }

}
