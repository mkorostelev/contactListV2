//
//  MagicValues.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct Constants {
    struct NotificationsNames {
        static let addContact = "addContact"
        
        static let removeContact = "removeContact"
        
        static let updateContact = "updateContact"
        
        static let changedSortFild = "changedSortFild"
    }
    
    struct UsersDefaultsKeys {
        static let sortFieldCode = "sortFieldCode"
    }
    
    struct SomeDefaults {
        static let countOfDisplayedFullNameCharacters = 15
    }
    
    struct Settings {
        static let useAlertControllerForUserAdd = false
        
        static let viewContactViaSecondClick = true
    }
}
