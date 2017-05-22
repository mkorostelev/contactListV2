//
//  SaveContacts.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct SaveLoadCheckData {
    static let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    static let fileURL = DocumentDirURL.appendingPathComponent("ContactsList")
    
    static func toDrive(_ listOfContacts : [Contact]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: listOfContacts)
        
        do {
            try encodedData.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    static func fromDrive() -> [Contact] {
        var result = [Contact]()
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            if let listOfContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
                result = listOfContacts
            }
        } catch {
            print(error)
        }
        
        return result        
    }
    
    static func setUsersDefaultSortMethod(_ sortMethod : AdditionalData.SortFields.Values){
        UserDefaults.standard.setValue(sortMethod.rawValue, forKey: Constants.UsersDefaultsKeys.sortFieldCode)
    }
    
    static func getUsersDefaultSortMethod() -> AdditionalData.SortFields.Values {
        var result = AdditionalData.SortFields.Values.lastName
        
        if let savedSortFieldCode = UserDefaults.standard.value(forKey: Constants.UsersDefaultsKeys.sortFieldCode) {
            if let savedSortFieldValue = AdditionalData.SortFields.Values(rawValue: savedSortFieldCode as! Int) {
                result = savedSortFieldValue
            }
        }
        
        return result
    }
    
    static func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "[\\d,.#*+()]{0,}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
}
