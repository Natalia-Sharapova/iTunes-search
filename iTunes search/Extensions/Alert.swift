//
//  Alert.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 27.03.2022.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
