//
//  SaveContacts.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct SaveLoadData {
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
    
    static func setUsersDefaultSortMethod(_ sortMethod : ContactsList.SortField){
        UserDefaults.standard.setValue(sortMethod.rawValue, forKey: Constants.usersDefaultsKeys.sortFieldCode)
    }
    
    static func getUsersDefaultSortMethod() -> ContactsList.SortField? {
        if let savedSortFieldCode = UserDefaults.standard.value(forKey: Constants.usersDefaultsKeys.sortFieldCode) {
            return ContactsList.SortField(rawValue: savedSortFieldCode as! Int)
        }
        
        return nil
    }
}
