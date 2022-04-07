//
//  SignUpViewController.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 22.03.2022.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var firstNameValidLabel: UILabel!
    @IBOutlet weak var secondNameValidLabel: UILabel!
    @IBOutlet weak var ageValidLabel: UILabel!
    @IBOutlet weak var phoneValidLabel: UILabel!
    @IBOutlet weak var emailValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let nameValidType = String.ValidTypes.name
    let emailValidType = String.ValidTypes.email
    let passwordValidType = String.ValidTypes.password
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotification()
        
        navigationItem.title = "New user"
        
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signUpButton.backgroundColor = .darkGray
        signUpButton.alpha = 0.7
        signUpButton.layer.cornerRadius = 20
        signUpButton.tintColor = .white
        signUpButton.titleLabel?.font = UIFont(name: "Gill Sans", size: 20)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.setTitle("Sign up", for: .normal)
    }
    
    deinit {
        removekeyboardNotification()
    }
    
    // Check if age is valid
    
    private func ageIsValid() -> Bool {
        
        let calendar = NSCalendar.current
        let dateNow = Date()
        
        let birthday = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        
        let ageYear = age.year
        
        guard let ageUser = ageYear else {
            return false
        }
        
        guard ageUser > 18 else {
            ageValidLabel.text = "Age is not valid"
            ageValidLabel.textColor = .red
            return false
        }
        
        ageValidLabel.text = "Age is valid"
        ageValidLabel.textColor = .green
        
        return true
    }
    
    private func setPhoneNumberMask(textField: UITextField, string: String, range: NSRange, mask: String) -> String {
        
        let text = textField.text ?? ""
        
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        
        let number = phone.replacingOccurrences(of: "[^0-9]",
                                                with: "",
                                                options: .regularExpression)
        
        var result = ""
        
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            
            if character == "X" {
                
                result.append(number[index])
                index = number.index(after: index)
                
            } else {
                
                result.append(character)
            }
        }
        
        if result.count == 18 {
            phoneValidLabel.text = "Phone is valid"
            phoneValidLabel.textColor = .green
            
        } else {
            
            phoneValidLabel.text = "Phone is not valid"
            phoneValidLabel.textColor = .red
        }
        return result
    }
    
    private func setTextField(textField: UITextField, validType: String.ValidTypes, label: UILabel, range: NSRange, string: String, validMessage: String, wrongMessage: String) {
        
        let text = (textField.text ?? "") + string
        
        let result: String
        
        if range.length == 1 {
            
            let endIndex = text.index(text.startIndex, offsetBy: text.count - 1)
            
            result = String(text[text.startIndex..<endIndex])
            
        } else {
            
            result = text
        }
        
        textField.text = result
        
        if result.isValid(validType: validType) {
            
            label.text = validMessage
            label.textColor = .green
            
        } else {
            
            label.text = wrongMessage
            label.textColor = .red
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        
        case firstNameTextField:
            
            setTextField(textField: textField,
                         validType: nameValidType,
                         label: firstNameValidLabel,
                         range: range,
                         string: string,
                         validMessage: "Name is valid",
                         wrongMessage: "Name should contain only A-Z characters, min 1 character")
            
        case secondNameTextField:
            
            setTextField(textField: textField,
                         validType: nameValidType,
                         label: secondNameValidLabel,
                         range: range,
                         string: string,
                         validMessage: "Name is valid",
                         wrongMessage: "Name should contain only A-Z characters, min 1 character")
            
        case emailTextField:
            
            setTextField(textField: textField,
                         validType: emailValidType,
                         label: emailValidLabel,
                         range: range,
                         string: string,
                         validMessage: "E-mail is valid",
                         wrongMessage: "E-mail is not valid")
            
        case passwordTextField:
            
            setTextField(textField: textField,
                         validType: passwordValidType,
                         label: passwordValidLabel,
                         range: range,
                         string: string,
                         validMessage: "Password is valid",
                         wrongMessage: "Password is not valid")
            
        case phoneNumberTextField:
            
            phoneNumberTextField.text = setPhoneNumberMask(textField: textField,
                                                           string: string,
                                                           range: range,
                                                           mask: "+X (XXX) XXX-XX-XX")
        default:
            break
        }
        
        return false
    }
    
    // MARK: - Actions
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        ageIsValid()
    }
    
    
    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""
        
        guard firstNameText.isValid(validType: nameValidType)
                && secondNameText.isValid(validType: nameValidType)
                && emailText.isValid(validType: emailValidType)
                && passwordText.isValid(validType: passwordValidType)
                && phoneText.count == 18
                && ageIsValid() == true else {
            
            navigationItem.title = "New user"
            alert(title: "Error", message: "Fill in all the fields. Your age should be 18+ y.o.")
            return
        }
        
        ImprovisedDataBase.shared.saveUser(firstName: firstNameText,
                                           secondName: secondNameText,
                                           phone: phoneText,
                                           password: passwordText,
                                           email: emailText,
                                           age: datePicker.date)
        
        navigationItem.title = "Registration complete"
    }
    
}

// MARK: - Extensions

// Scroll content with showing/hiding keyboard

extension SignUpViewController {
    
    private func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo
        
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 10)
    }
    
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        scrollView.contentOffset = CGPoint.zero
    }
    
    private func removekeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
}

