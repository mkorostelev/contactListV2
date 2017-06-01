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
    
    func viewDidLoad()
    
    func checkSaveContact()
    
    func deleteContact()
}

class ContactAddEditPresenter: NSObject, ContactAddEditPresenterProtocol, UITextFieldDelegate {
    unowned let view: ContactAddEditProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    let contact: Contact?
    
    var viewFirstNameText: String {
        return self.view.firstNameTextField.text ?? ""
    }
    
    var viewLastNameText: String {
        return self.view.lastNameTextField.text ?? ""
    }
    
    var viewPhoneNumberText: String {
        return self.view.phoneNumberTextField.text ?? ""
    }
    
    var viewEmailText: String {
        return self.view.emailTextField.text ?? ""
    }
    
    var validationError = false
    
    required init(view: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.view = view
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
        
        self.contact = contactList?.getByUuid(contactUuid)
    }
    
    func viewDidLoad() {
        self.view.firstNameTextField.delegate = self
        
        self.view.lastNameTextField.delegate = self
        
        self.view.phoneNumberTextField.delegate = self
        
        self.view.emailTextField.delegate = self
        
        if self.contact != nil {
            self.fillDataFromContact(self.contact!)
        } else {
            self.view.deleteContactButton.isHidden = true
        }
        
        self.checkEnabledOfSaveButton()
    }
    
    func fillDataFromContact(_ contact: Contact) {
        self.view.firstNameTextField.text = contact.firstName
        
        self.view.lastNameTextField.text = contact.lastName
        
        self.view.phoneNumberTextField.text = contact.phoneNumber
        
        self.view.emailTextField.text = contact.email
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.view.phoneNumberTextField {
            result = DataValidators.validatePhoneNumberInput(value: string)
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
        
        let saveContactOutletisEnabled = ("\(self.viewFirstNameText)\(self.viewLastNameText)\(self.viewPhoneNumberText)\(self.viewEmailText)\(notInOutletString)".characters.count - countOfDeleted) > 0
        
        self.view.saveContactButton.isEnabled = saveContactOutletisEnabled
    }
    
    func checkSaveContact() {
        if !("\(viewFirstNameText)\(viewLastNameText)\(viewPhoneNumberText)\(viewEmailText)".isEmpty) {
            if let view = self.view as? UIViewController {
                if DataValidators.validateEmail(value: viewEmailText) {
                    saveContact()
                } else {
                    let ac = UIAlertController(title: "Email", message: "not valid", preferredStyle: .alert)
                    
                    ac.addAction(UIAlertAction(title: "Save", style: .cancel) { _ in self.saveContact()})
                    
                    ac.addAction(UIAlertAction(title: "Check", style: .destructive))
                    
                    view.present(ac, animated: true, completion:nil)
                }
            }
        }
    }
    
    private func saveContact() {
        if let contactValue = self.contact {
            // change contact
            if contactValue.firstName != viewFirstNameText {
                contactValue.firstName = viewFirstNameText
            }
            if contactValue.lastName != viewLastNameText {
                contactValue.lastName = viewLastNameText
            }
            if contactValue.phoneNumber != viewPhoneNumberText {
                contactValue.phoneNumber = viewPhoneNumberText
            }
            if contactValue.email != viewEmailText {
                contactValue.email = viewEmailText
            }
        } else {
            // add new contact
            contactList?.addContact(firstName: viewFirstNameText, lastName: viewLastNameText, phoneNumber: viewPhoneNumberText, email: viewEmailText)
        }
        
        if let view = self.view as? UIViewController {
            view.performSegueToReturnBack()
        }
    }
    
    func deleteContact() {
        if let view = self.view as? UIViewController {
            let ac = AlertsCreator.getDeleteContactAlert(contact!, deleteAction: deleteContactConfirmed)
            
            view.present(ac, animated: true)
        }
    }
    
    func deleteContactConfirmed(_ contact: Contact) {
        contactList?.deleteContact(contact)
        
        if let view = self.view as? UIViewController {
            view.performSegueToReturnBack()
        }
    }
}
















