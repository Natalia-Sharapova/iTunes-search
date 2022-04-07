//
//  UserInfoViewController.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 23.03.2022.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Active user"
        setLabels()
    }
    
    private func setLabels() {
        
        guard let activeUser = ImprovisedDataBase.shared.activeUser else { return }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: activeUser.age)
        
        firstNameLabel.text = activeUser.firstName
        secondNameLabel.text = activeUser.secondName
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
        ageLabel.text = dateString
    }
    
}
