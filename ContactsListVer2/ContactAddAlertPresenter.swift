//
//  ContactAddAlertPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/9/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactAddAlertPresenterProtocol: ContactAddBaseProtocol {
    init(contactAddAlert: ContactAddAlert, contactList: ContactsList?)
    
//    func checkAndSaveContactFromAlert(firstName: String, lastName: String, phoneNumber: String, email: String)
//    
//    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?)
}

class ContactAddAlertPresenter: ContactAddAlertPresenterProtocol {
    unowned var connectedController: ControllerWithSaveButton
    
    let contactList: ContactsList?
    
    required init(contactAddAlert: ContactAddAlert, contactList: ContactsList?) {
        self.connectedController = contactAddAlert
        
        self.contactList = contactList
    }
    
    func validateAndSaveContact(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?) {
        if !"\(firstName)\(lastName)\(phoneNumber)\(email)".isEmpty {
            self.contactList?.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: nil)
        }
    }
    
//    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?) {
//        var countOfDeleted = 0
//        
//        if let rangeValue = range {
//            if notInOutletString.isEmpty {
//                countOfDeleted = rangeValue.length - rangeValue.location
//            }
//        }
//        
//        let saveContactOutletisEnabled = ("\(allInputedText)\(notInOutletString)".characters.count - countOfDeleted) > 0
//        
//        self.contactAddAlert.okAlertActionIsEnabled = saveContactOutletisEnabled
//    }
}
