//
//  ContactAddEditPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactAddEditPresenterProtocol {
    init(view: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func fillDataFromContact()
    
    func viewDidLoad()
    
    func saveContact()
    
    func deleteContact()
}

class ContactAddEditPresenter: NSObject, ContactAddEditPresenterProtocol, UITextFieldDelegate {
    unowned let view: ContactAddEditProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    let contact: Contact?
    
    required init(view: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.view = view
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
        
        self.contact = contactList?.getByUuid(contactUuid)
    }
    
    func viewDidLoad() {
        self.view.setTextFieldsDelegate(delegate: self)
        
        self.fillDataFromContact()
        
        self.checkEnabledOfSaveButton()
    }
    
    func fillDataFromContact() {
        if let contact = contactList?.getByUuid(contactUuid) {
            let firstName = contact.firstName
            
            let lastName = contact.lastName
            
            let phoneNumber = contact.phoneNumber
            
            let email = contact.email
            
            self.view.fillDataFromContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        } else {
            self.view.setDeleteContactOutletIsHidden(true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.view.phoneNumberTextField {
            result = SaveLoadCheckData.validatePhoneNumber(value: string)
        }
        
        if result {
            checkEnabledOfSaveButton(notInOutletString: string, range: range)
        }
        
        return result
    }
    
    private func checkEnabledOfSaveButton(notInOutletString: String = "", range: NSRange? = nil) {
        var countOfDeleted = 0
        
        if let rangeValue = range {
            if notInOutletString.isEmpty {
                countOfDeleted = rangeValue.length - rangeValue.location
            }
        }

        let firstName = self.view.firstNameTextField.text ?? ""
        
        let lastName = self.view.lastNameTextField.text ?? ""
        
        let phoneNumber = self.view.phoneNumberTextField.text ?? ""
        
        let email = self.view.emailTextField.text ?? ""
        
        let saveContactOutletisEnabled = ("\(firstName)\(lastName)\(phoneNumber)\(email)\(notInOutletString)".characters.count - countOfDeleted) > 0
        
        self.view.setSaveContactOutletIsEnabled(saveContactOutletisEnabled)
    }
    
    func saveContact() {
        let firstName = self.view.firstNameTextField.text ?? ""
        
        let lastName = self.view.lastNameTextField.text ?? ""
        
        let phoneNumber = self.view.phoneNumberTextField.text ?? ""
        
        let email = self.view.emailTextField.text ?? ""
        
        if !("\(firstName)\(lastName)\(phoneNumber)\(email)".isEmpty) {
            if let contactValue = self.contact {
                // change contact
                if contactValue.firstName != firstName {
                    contactValue.firstName = firstName
                }
                if contactValue.lastName != lastName {
                    contactValue.lastName = lastName
                }
                if contactValue.phoneNumber != phoneNumber {
                    contactValue.phoneNumber = phoneNumber
                }
                if contactValue.email != email {
                    contactValue.email = email
                }
            } else {
                // add new contact
                contactList?.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
            }
            
            if let view = self.view as? UIViewController {
                view.performSegueToReturnBack()
            }
        }
    }
    
    func deleteContact() {
        if let contactValue = contact {
            contactList?.deleteContact(contactValue)
        }
        
        if let view = self.view as? UIViewController {
            view.performSegueToReturnBack()
        }
    }
}
















