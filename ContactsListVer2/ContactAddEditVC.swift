//
//  ContactAddEditVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddEditVC: UIViewController, ContactsListProtocol, ContactProtocol {
    var contactList: ContactsList?
    
    var contact: Contact?
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var deleteContactOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDataFromContact()
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
        
        if "\(firstName)\(lastName)\(phoneNumber)\(email)" != "" {
            if let contactListValue = contactList {
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
                    contactListValue.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                }
            }
            self.performSegueToReturnBack()
        }
    }
    @IBAction func deleteContact(_ sender: UIButton) {
        if let contactValue = contact {
            if let contactListValue = contactList{
                contactListValue.deleteContact(contactValue)
            }
        }
        self.performSegueToReturnBack()
    }
}
