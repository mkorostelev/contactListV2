//
//  Validators.swift
//  ContactsListVer2
//
//  Created by Admin on 6/1/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct DataValidators {
    static func validatePhoneNumberInput(value: String) -> Bool {
        let PHONE_REGEX = "[\\d,.#*+()]{0,}"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluate(with: value)
        
        return result
    }
    
    static func validateEmail(value: String) -> Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
        
        let result =  emailTest.evaluate(with: value)
        
        return result
    }
}
