//
//  MagicValues.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

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
        
        static let countOfDisplayedEmailOrPhoneNumberCharacters = 20
        
        static let accessoryButtons = [#imageLiteral(resourceName: "button_0"), #imageLiteral(resourceName: "button_1"), #imageLiteral(resourceName: "button_2")]
    }
    
    struct Settings {
        static let useAlertControllerForUserAdd = false
        
        static let viewContactViaSecondClick = true
        
        static let useApiForStorageData = true
    }
}
