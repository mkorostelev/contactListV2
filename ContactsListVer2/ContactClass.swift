//
//  ContactClass.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class Contact: NSObject, NSCoding{
    var firstName: String
    {
        didSet {
            Notifications.postUpdateContact(self)
        }
    }
    
    var lastName: String
    {
        didSet {
            Notifications.postUpdateContact(self)
        }
    }
    
    var phoneNumber: String
    {
        didSet {
            Notifications.postUpdateContact(self)
        }
    }
    
    var email: String
    {
        didSet {
            Notifications.postUpdateContact(self)
        }
    }
    
    private(set) var uuid: String
    
    var searchString: String {
        return "\(self.firstName) \(self.lastName) \(self.phoneNumber) \(self.email)"
    }
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, email: String) {
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.phoneNumber = phoneNumber
        
        self.email = email
        
        self.uuid = UUID().uuidString
    }
    
    override init() {
        self.firstName = ""
        
        self.lastName = ""
        
        self.phoneNumber = ""
        
        self.email = ""
        
        self.uuid = UUID().uuidString
    }
    
    required init(coder decoder: NSCoder) {
        self.firstName = decoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lastName = decoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.phoneNumber = decoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.uuid = decoder.decodeObject(forKey: "uuid") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.firstName, forKey: "firstName")
        coder.encode(self.lastName, forKey: "lastName")
        coder.encode(self.phoneNumber, forKey: "phoneNumber")
        coder.encode(self.email, forKey: "email")
        coder.encode(self.uuid, forKey: "uuid")
    }
}
