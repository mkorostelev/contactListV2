//
//  ContactViewVC.swift
//  ContactsListVer2
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactViewVC: UIViewController, ContactsListProtocol,ContactProtocol {
    var contactList: ContactsList?
    
    var contact: Contact?
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDataFromContact()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fillDataFromContact() {
        if let contactValue = contact {
            self.navigationItem.title = contactValue.fullName
            
            phoneNumberOutlet.text = contactValue.phoneNumber
            
            emailOutlet.text = contactValue.email
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                toViewController.contactList = contactList
                toViewController.contact = contact
            }
        }
    }
}
