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
    
    func fillCellByContact(constraintsConstant: Int)
}

class ContactTVCellPresenter: ContactTVCellPresenterProtocol {
    unowned var contactsTVCell: ContactTVCellProtocol
    
    var showDetailInfo = false
    
    private let contact: Contact
    
    required init(contactsTVCell: ContactTVCellProtocol, contact: Contact) {
        self.contactsTVCell = contactsTVCell
        
        self.contact = contact
    }
    
    func fillCellByContact(constraintsConstant: Int) {        
        contactsTVCell.fillCell(
            fullName: contact.fullName,
            firstName: contact.firstName,
            lastName: contact.lastName,
            phoneNumber: contact.phoneNumber,
            email: contact.email,
            photo: contact.photo,
            constraintsConstant: constraintsConstant
        )
    }
}
