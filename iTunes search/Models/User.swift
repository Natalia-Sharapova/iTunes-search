//
//  UserModel.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 27.03.2022.
//

import Foundation

struct User: Codable {
    
    let firstName: String
    let secondName: String
    let phone: String
    let password: String
    let email: String
    let age: Date
    
}
