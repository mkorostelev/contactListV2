//
//  ContactAddEditVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddEditVC: UIViewController, ContactsListProtocol, ContactProtocol, UITextFieldDelegate {
    
    var contactList: ContactsList?
    
    var contactUuid: String?
    
    var contact: Contact?
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var deleteContactOutlet: UIButton!
    
    @IBOutlet weak var saveContactOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contact = contactList?.getByUuid(contactUuid)
        
        fillDataFromContact()
        
        phoneNumberOutlet.delegate = self
        
        firstNameOutlet.delegate = self
        
        lastNameOutlet.delegate = self
        
        emailOutlet.delegate = self
        
        checkEnabledOfSaveButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fillDataFromContact() {
        if let contactValue = contact {
            firstNameOutlet.text = contactValue.firstName
            
            lastNameOutlet.text = contactValue.lastName
            
            phoneNumberOutlet.text = contactValue.phoneNumber
            
            emailOutlet.text = contactValue.email
        } else {
            deleteContactOutlet.isHidden = true
        }
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        let firstName = firstNameOutlet.text ?? ""
        let lastName = lastNameOutlet.text ?? ""
        let phoneNumber = phoneNumberOutlet.text ?? ""
        let email = emailOutlet.text ?? ""
        
        if !("\(firstName)\(lastName)\(phoneNumber)\(email)".isEmpty) {
            if let contactValue = contact {
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
            
            self.performSegueToReturnBack()
        }
    }
    @IBAction func deleteContact(_ sender: UIButton) {
        if let contactValue = contact {
                contactList?.deleteContact(contactValue)
        }
        self.performSegueToReturnBack()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var result = true
        if textField == phoneNumberOutlet {
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
        
        let firstName = firstNameOutlet.text ?? ""
        let lastName = lastNameOutlet.text ?? ""
        let phoneNumber = phoneNumberOutlet.text ?? ""
        let email = emailOutlet.text ?? ""
        
        saveContactOutlet.isEnabled = ("\(firstName)\(lastName)\(phoneNumber)\(email)\(notInOutletString)".characters.count - countOfDeleted) > 0
    }
}
