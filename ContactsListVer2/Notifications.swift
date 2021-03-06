//
//  Notifications.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct Notifications {
    static func postAddContact(_ contact: Contact) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsNames.addContact), object: nil, userInfo: ["contact": contact])
    }
    
    static func postRemoveContact(_ contact: Contact) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsNames.removeContact), object: nil, userInfo: ["contact": contact])
    }
    
    static func postUpdateContact(_ contact: Contact) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsNames.updateContact), object: nil, userInfo: ["contact": contact])
    }
    
    static func postChangedSortField() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsNames.changedSortFild), object: nil)
    }
}
