//
//  ContactAddBase.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/21/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ControllerWithSaveButton: class {
    var saveButtonIsEnabled: Bool { get set }
}

protocol ContactAddBaseProtocol: class {
    func validateAndSaveContact(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?)
    
    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?)
    
    unowned var connectedController: ControllerWithSaveButton { get set }
}

extension ContactAddBaseProtocol {
    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?) {
        var countOfDeleted = 0
        
        if let rangeValue = range {
            if notInOutletString.isEmpty {
                countOfDeleted = rangeValue.length - rangeValue.location
            }
        }
        
        let saveContactOutletisEnabled = ("\(allInputedText)\(notInOutletString)".characters.count - countOfDeleted) > 0
        
        self.connectedController.saveButtonIsEnabled = saveContactOutletisEnabled
    }
}
