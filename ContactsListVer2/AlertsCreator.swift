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
    static func getDeleteContactAlert(contactFullName: String, deleteAction: @escaping (() -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: contactFullName, message: "will be deleted", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive) { _ in deleteAction()})
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        return alertController
    }
    
    static func getEmailValidationAlert(email: String, saveAction: @escaping (() -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: email, message: "not valid email", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .cancel) { _ in saveAction()})
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
        
        return alertController
    }
}
