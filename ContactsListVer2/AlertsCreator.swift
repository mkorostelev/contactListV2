//
//  AlertsCreator.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/1/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

struct AlertsCreator {
    static func getDeleteContactAlert(_ contact: Contact, deleteAction: @escaping ((_ contact: Contact) -> Void)) -> UIAlertController {
        let ac = UIAlertController(title: contact.fullName, message: "will be deleted", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Confirm", style: .destructive) { _ in deleteAction(contact)})
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        return ac
    }
}








