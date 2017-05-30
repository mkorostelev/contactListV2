//
//  TVCellPresenterProtocol.swift
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








