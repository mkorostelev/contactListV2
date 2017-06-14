//
//  ContactAddEditProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactAddEditProtocol: class {
    var deleteContactButtonIsHidden: Bool { get set }
    
    var saveButtonIsEnabled: Bool { get set }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void))
    
    func presentEmailValidationAlert(saveAction: @escaping (() -> Void))
    
    func closeView()
    
    func fillTextFieldsData(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?,
                            longitude: Double?)
    
    func setLocation(latitude: Double, longitude: Double)
}
