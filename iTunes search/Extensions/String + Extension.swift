//
//  Extensions.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 26.03.2022.
//

import Foundation

extension String {
    
    enum ValidTypes {
        
        case name
        case email
        case password
    }
    
    enum RegularExpressions: String {
        
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._]+@[a-zA-Z0-9]+\\.[a-zA-Z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        
        let format = "SELF MATCHES %@"
        
        var regularExpression = ""
        
        switch  validType {
        case .name:
            regularExpression = RegularExpressions.name.rawValue
        case .email:
            regularExpression = RegularExpressions.email.rawValue
        case .password:
            regularExpression = RegularExpressions.password.rawValue
        }
        
        return NSPredicate(format: format, regularExpression).evaluate(with: self)
    }
}
