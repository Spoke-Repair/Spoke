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
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        self.textField.underline()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        var newString = ""
        
        //alternative route if char was deleted from password field
        if(newLength < (textField.text?.count)! && phoneNumberEntered) {
            textField.text!.removeLast()
            return false
        }
        
        //alternative logic to see if character was deleted
        if(newLength < (textField.text?.count)! && !phoneNumberEntered) {
            
            //(210) - 4
            if(newLength == 8){
                textField.text = CommonUtils.strip(from: textField.text!, characters: ["-", " ", ")"])
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
            button.addTarget(self, action: #selector(self.enteredSecondPassword), for: .touchUpInside)
            self.instructionLabel.text = "Now re-enter your password"
            self.textField.rightView = button
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.isSecureTextEntry = true
            self.textField.rightViewMode = .always
            
            self.textField.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
    @objc func enteredSecondPassword() {
        guard !(self.textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter a password", sender: self)
            return
        }
        guard self.textField.text == self.password else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.errMsgStr = "Passwords must match!"
            self.present(vc, animated: true, completion: nil)
            return
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerEnterAuthVC") as? CustomerEnterAuthVC else {
            CommonUtils.popUpAlert(message: "Can't transition to view", sender: self)
            return
        }
        vc.user = PFUser()
        vc.user?.username = CommonUtils.strip(from: self.phoneNumber, characters: ["-", " ", "(", ")"])
        vc.user?.password = self.password
        vc.user?["type"] = "customer"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
