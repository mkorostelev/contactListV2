//
//  ContactTVCellPresenter.swift
//  ContactsListVer2
//
//  Created by Admin on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactTVCellPresenterProtocol {
    init(contactsTVCell: ContactTVCellProtocol, contact: Contact)
    
    func fillCellByContact()
}

class ContactTVCellPresenter: ContactTVCellPresenterProtocol {
    unowned let contactsTVCell: ContactTVCellProtocol
    
    private let contact: Contact
    
    required init(contactsTVCell: ContactTVCellProtocol, contact: Contact) {
        self.contactsTVCell = contactsTVCell
        
        self.contact = contact
    }
    
    func fillCellByContact() {
        let fullName = self.contact.fullName
        
        let phoneNumber = self.contact.phoneNumber
        
        contactsTVCell.fillCell(fullName: fullName, phoneNumber: phoneNumber)
    }
}
