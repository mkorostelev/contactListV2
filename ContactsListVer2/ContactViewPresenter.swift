//
//  ContactViewPresenter.swift
//  ContactsListVer2
//
//  Created by Admin on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactViewPresenterProtocol: class {
    init(contactViewVC: ContactViewProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func viewDidLoad()
    
    var contactList: ContactsList? { get }
    
    var contactUuid: String? { get }
    
    var router: ContactViewRouterProtocol! { get set }
}

class ContactViewPresenter: ContactViewPresenterProtocol {
    unowned let contactViewVC: ContactViewProtocol
    
    var router: ContactViewRouterProtocol!
    
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
            
            self.contactViewVC.fillDataFromContact(title: title, phoneNumber: phoneNumber, email: email, photo: contact.photo)
        }
    }
}
