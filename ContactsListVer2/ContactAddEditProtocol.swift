//
//  ContactAddEditProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactAddEditProtocol: class, ControllerWithSaveButton {
    var deleteContactButtonIsHidden: Bool { get set }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void))
    
    func presentEmailValidationAlert(saveAction: @escaping (() -> Void))
    
    func closeViewAndGoBack()
    
    func closeViewAndGoToRoot()
    
    func fillTextFieldsData(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?,
                            longitude: Double?)
    
    func setLocation(latitude: Double?, longitude: Double?, address: String?)
    
    func getLocationInfo() -> (fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?)
    
    func fillContactsLocation()
}
