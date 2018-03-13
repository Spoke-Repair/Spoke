import UIKit
import Parse

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    var currentlyEnteringPhone = true
    var phoneNumber = ""
    var password:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        self.textField.underline()
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
        button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
        button.addTarget(self, action: #selector(self.enteredPhone), for: .touchUpInside)
        self.textField.rightView = button
        self.textField.rightViewMode = .always
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.applyPhoneFormatForUITextFieldDelegate(replacementString: string, currentlyEnteringPhone: currentlyEnteringPhone)
    }
    
    @objc func enteredPhone() {
        guard textField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter your complete phone number", sender: self)
            return
        }
        UIView.animate(withDuration: 1, animations: {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.enteredFirstPassword), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
            
            self.phoneNumber = self.textField.text!
            self.currentlyEnteringPhone = false
            self.textField.placeholder = "Enter a password"
            self.textField.text = ""
            self.instructionLabel.text = "Enter your password"
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.isSecureTextEntry = true
            self.textField.center.x += self.view.bounds.width
        }, completion: nil)
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
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
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
            vc.errMsgStr = "Unable to create account - passwords must match!"
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
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            CommonUtils.popUpAlert(message: "Can't transiton to view", sender: self)
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
}
