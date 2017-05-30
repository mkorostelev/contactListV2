//
//  ContactTVCellPresenter.swift
//  ContactsListVer2
//
//  Created by Admin on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactTVCellPresenterProtocol {
    init(view: ContactTVCellProtocol, contact: Contact)
    
    func fillCellByContact()
}

class ContactTVCellPresenter: ContactTVCellPresenterProtocol {
    unowned let view: ContactTVCellProtocol
    
    let contact: Contact
    
    required init(view: ContactTVCellProtocol, contact: Contact) {
        self.view = view
        
        self.contact = contact
    }
    
    func fillCellByContact() {
        let fullName = self.contact.fullName
        
        let phoneNumber = self.contact.phoneNumber
        
        view.fillCell(fullName: fullName, phoneNumber: phoneNumber)
    }
}








