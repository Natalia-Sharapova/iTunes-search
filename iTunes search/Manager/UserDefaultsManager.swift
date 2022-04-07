//
//  UserDefaultsManager.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 27.03.2022.
//

import Foundation

class ImprovisedDataBase {
    
    private init() {}
    
    static let shared = ImprovisedDataBase()
    
    enum SettingKeys: String {
        case users
        case activeUser
    }
    
    let defaults = UserDefaults.standard
    
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue
    
    var users: [User] {
        
        get {
            guard let data = defaults.value(forKey: userKey) as? Data else {
                return [User]()
            }
            return try! PropertyListDecoder().decode([User].self, from: data)
        }
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else {
                return
            }
            defaults.set(data, forKey: userKey)
        }
    }
    
    var activeUser: User? {
        
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else {
                return
            }
            defaults.set(data, forKey: activeUserKey)
        }
    }
    
    func saveUser(firstName: String, secondName: String, phone: String, password: String, email: String, age: Date) {
        
        let user = User(firstName: firstName, secondName: secondName, phone: phone, password: password, email: email, age: age)
        
        users.insert(user, at: 0)
    }
    
    func saveActiveUser(user: User) {
        
        activeUser = user
    }
}
