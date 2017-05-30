//
//  ContactViewPresenter.swift
//  ContactsListVer2
//
//  Created by Admin on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactViewPresenterProtocol {
    init(view: ContactViewProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func fillDataFromContact()
    
    func viewDidLoad()
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class ContactViewPresenter: ContactViewPresenterProtocol {
    unowned let view: ContactViewProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    required init(view: ContactViewProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.view = view
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
    }

    func viewDidLoad() {
        self.fillDataFromContact()
    }
    
    func fillDataFromContact() {
        if let contact = contactList?.getByUuid(contactUuid) {
            let title = contact.fullName
            
            let phoneNumber = contact.phoneNumber
            
            let email = contact.email
            
            self.view.fillDataFromContact(title: title, phoneNumber: phoneNumber, email: email)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                toViewController.contactList = contactList
                toViewController.contactUuid = contactUuid
            }
        }
    }
}







