//
//  Notifications.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct Notifications {
    static func postAddRemoveContact() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notificationsNames.addRemoveContact), object: nil)
    }
    
    static func postUpdateContact(_ contact: Contact) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notificationsNames.updateContact), object: nil, userInfo: ["contact" : contact])
    }
}
