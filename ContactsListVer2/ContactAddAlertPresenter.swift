//
//  ContactAddAlertPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/9/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactAddAlertPresenterProtocol {
    init(contactAddAlert: ContactAddAlert, contactList: ContactsList?)
    
    func checkAndSaveContactFromAlert(firstName: String, lastName: String, phoneNumber: String, email: String)
    
    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?)
}

class ContactAddAlertPresenter: ContactAddAlertPresenterProtocol {
    unowned let contactAddAlert: ContactAddAlert
    
    let contactList: ContactsList?
    
    required init(contactAddAlert: ContactAddAlert, contactList: ContactsList?) {
        self.contactAddAlert = contactAddAlert
        
        self.contactList = contactList
    }
    
    func checkAndSaveContactFromAlert(firstName: String, lastName: String, phoneNumber: String, email: String) {
        if !"\(firstName)\(lastName)\(phoneNumber)\(email)".isEmpty {
            self.contactList?.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        }
    }
    
    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?) {
        var countOfDeleted = 0
        
        if let rangeValue = range {
            if notInOutletString.isEmpty {
                countOfDeleted = rangeValue.length - rangeValue.location
            }
        }
        
        let saveContactOutletisEnabled = ("\(allInputedText)\(notInOutletString)".characters.count - countOfDeleted) > 0
        
        self.contactAddAlert.okAlertActionIsEnabled = saveContactOutletisEnabled
    }
}
