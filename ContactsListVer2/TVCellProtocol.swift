//
//  TVCellProtocol.swift
//  ContactsListVer2
//
//  Created by Admin on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol  ContactTVCellProtocol: class {
    func fillCell(fullName: String, firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, constraintsConstant: Int)
    
    func reloadDataFromPresenter()
}
