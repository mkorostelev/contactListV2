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
    init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func viewDidLoad()
    
    func checkSaveContact()
    
    func deleteContact()
}

class ContactAddEditPresenter: NSObject, ContactAddEditPresenterProtocol, UITextFieldDelegate {
    unowned let contactAddEditVC: ContactAddEditProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    private let contact: Contact?
    
    private var viewFirstNameText: String {
        return self.contactAddEditVC.firstNameTextField.text ?? ""
    }
    
    private var viewLastNameText: String {
        return self.contactAddEditVC.lastNameTextField.text ?? ""
    }
    
    private var viewPhoneNumberText: String {
        return self.contactAddEditVC.phoneNumberTextField.text ?? ""
    }
    
    private var viewEmailText: String {
        return self.contactAddEditVC.emailTextField.text ?? ""
    }
    
    required init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.contactAddEditVC = contactAddEditVC
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
        
        self.contact = contactList?.getByUuid(contactUuid)
    }
    
    func viewDidLoad() {
        self.contactAddEditVC.firstNameTextField.delegate = self
        
        self.contactAddEditVC.lastNameTextField.delegate = self
        
        self.contactAddEditVC.phoneNumberTextField.delegate = self
        
        self.contactAddEditVC.emailTextField.delegate = self
        
        if self.contact != nil {
            self.fillDataFromContact(self.contact!)
        } else {
            self.contactAddEditVC.deleteContactButton.isHidden = true
        }
        
        self.checkEnabledOfSaveButton()
    }
    
    private func fillDataFromContact(_ contact: Contact) {
        self.contactAddEditVC.firstNameTextField.text = contact.firstName
        
        self.contactAddEditVC.lastNameTextField.text = contact.lastName
        
        self.contactAddEditVC.phoneNumberTextField.text = contact.phoneNumber
        
        self.contactAddEditVC.emailTextField.text = contact.email
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.contactAddEditVC.phoneNumberTextField {
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
        
        self.contactAddEditVC.saveContactButton.isEnabled = saveContactOutletisEnabled
    }
    
    func checkSaveContact() {
        if !("\(viewFirstNameText)\(viewLastNameText)\(viewPhoneNumberText)\(viewEmailText)".isEmpty) {
            if let view = self.contactAddEditVC as? UIViewController {
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
        
        if let view = self.contactAddEditVC as? UIViewController {
            view.performSegueToReturnBack()
        }
    }
    
    func deleteContact() {
        if let view = self.contactAddEditVC as? UIViewController {
            let ac = AlertsCreator.getDeleteContactAlert(contact!, deleteAction: deleteContactConfirmed)
            
            view.present(ac, animated: true)
        }
    }
    
    private func deleteContactConfirmed(_ contact: Contact) {
        contactList?.deleteContact(contact)
        
        if let view = self.contactAddEditVC as? UIViewController {
            view.performSegueToReturnBack()
        }
    }
}
