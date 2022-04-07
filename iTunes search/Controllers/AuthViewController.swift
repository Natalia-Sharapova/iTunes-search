//
//  AuthViewController.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 21.03.2022.
//

import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotification()
        
        signInButton.backgroundColor = .black
        signInButton.alpha = 0.7
        signInButton.layer.cornerRadius = 20
        signInButton.tintColor = .white
        signInButton.titleLabel?.font = UIFont(name: "Gill Sans", size: 20)
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.setTitle("Sign in", for: .normal)
        
        signUpButton.backgroundColor = .darkGray
        signUpButton.alpha = 0.7
        signUpButton.layer.cornerRadius = 20
        signUpButton.tintColor = .white
        signUpButton.titleLabel?.font = UIFont(name: "Gill Sans", size: 20)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.setTitle("Sign up", for: .normal)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    deinit {
        removekeyboardNotification()
    }
    
    // Check is the user in the data base
    
    func findUserInDataBase(email: String) -> User? {
        
        let dataBase = ImprovisedDataBase.shared.users
        
        for user in dataBase {
            
            if user.email == email {
                return user
            }
        }
        return nil
    }
    
    
    // MARK: - Actions
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let user = findUserInDataBase(email: email)
        
        if user == nil {
            navigationItem.title = "User nor found"
            
        } else if user?.password == password {
            navigationItem.title = "User found"
            performSegue(withIdentifier: "ToTheAlbums", sender: nil)
            
            guard let activeUser = user else { return }
            ImprovisedDataBase.shared.saveActiveUser(user: activeUser)
            
        } else {
            navigationItem.title = "Wrong password"
        }
    }
    
    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

// MARK: - Extensions

// Scroll content with showing/hiding keyboard

extension AuthViewController {
    
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
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 3)
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


