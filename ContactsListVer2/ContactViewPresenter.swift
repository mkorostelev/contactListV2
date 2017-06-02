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
    init(contactViewVC: ContactViewProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func viewDidLoad()
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class ContactViewPresenter: ContactViewPresenterProtocol {
    unowned let contactViewVC: ContactViewProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    required init(contactViewVC: ContactViewProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.contactViewVC = contactViewVC
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
    }

    func viewDidLoad() {
        self.fillDataFromContact()
    }
    
    private func fillDataFromContact() {
        if let contact = contactList?.getByUuid(contactUuid) {
            let title = contact.fullName
            
            let phoneNumber = contact.phoneNumber
            
            let email = contact.email
            
            self.contactViewVC.fillDataFromContact(title: title, phoneNumber: phoneNumber, email: email)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                let presenter = ContactAddEditPresenter(contactAddEditVC: toViewController, contactList: contactList, contactUuid: contactUuid)
                
                toViewController.presenter = presenter
            }
        }
    }
}
