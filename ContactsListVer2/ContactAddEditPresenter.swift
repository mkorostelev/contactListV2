//
//  ContactAddEditPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactAddEditPresenterProtocol: class {
    init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func viewDidLoad()
    
    func deleteContact()
    
    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?)
    
    func validateAndSaveContact(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?)
    
    func setLocation(latitude: Double, longitude: Double)
}

class ContactAddEditPresenter: ContactAddEditPresenterProtocol {
    unowned let contactAddEditVC: ContactAddEditProtocol
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    private let contact: Contact?
    
    required init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.contactAddEditVC = contactAddEditVC
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
        
        self.contact = contactList?.getByUuid(contactUuid)
    }
    
    func viewDidLoad() {
        if let contactValue = self.contact {
            self.contactAddEditVC.fillTextFieldsData(
                firstName: contactValue.firstName,
                lastName: contactValue.lastName,
                phoneNumber: contactValue.phoneNumber,
                email: contactValue.email,
                photo: contactValue.photo,
                latitude: contactValue.latitude,
                longitude: contactValue.longitude
            )
        } else {
            self.contactAddEditVC.deleteContactButtonIsHidden = true
        }
    }

    func checkEnabledOfSaveButton(allInputedText: String, notInOutletString: String, range: NSRange?) {
        var countOfDeleted = 0
        
        if let rangeValue = range {
            if notInOutletString.isEmpty {
                countOfDeleted = rangeValue.length - rangeValue.location
            }
        }
        
        let saveContactOutletisEnabled = ("\(allInputedText)\(notInOutletString)".characters.count - countOfDeleted) > 0
        
        self.contactAddEditVC.saveButtonIsEnabled = saveContactOutletisEnabled
    }
    
    func validateAndSaveContact(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?) {
        if email.isEmpty || DataValidators.validateEmail(value: email) {
            self.saveContactConfirmed(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: latitude, longitude: longitude)
        } else {
            self.contactAddEditVC.presentEmailValidationAlert {
                self.saveContactConfirmed(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: latitude, longitude: longitude)
            }
        }
    }
    
    private func saveContactConfirmed(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?) {
        if let contactValue = self.contact {
            // change contact
            if contactValue.firstName != firstName {
                contactValue.firstName = firstName
            }
            if contactValue.lastName != lastName {
                contactValue.lastName = lastName
            }
            if contactValue.phoneNumber != phoneNumber {
                contactValue.phoneNumber = phoneNumber
            }
            if contactValue.email != email {
                contactValue.email = email
            }
            
            if contactValue.photo != photo {
               contactValue.photo = photo
            }
            
            if contactValue.latitude != latitude {
                contactValue.latitude = latitude
            }
            
            if contactValue.longitude != longitude {
                contactValue.longitude = longitude
            }
        } else {
            // add new contact
            contactList?.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: latitude, longitude: longitude)
        }
        
        self.contactAddEditVC.closeView()
    }
    
    func deleteContact() {
        self.contactAddEditVC.presentDeletionAlert(contactFullName: contact?.fullName ?? "Contact") {
            self.deleteContactConfirmed()
        }
    }
    
    private func deleteContactConfirmed() {
        if let contact = self.contact {
            contactList?.deleteContact(contact)
            
            self.contactAddEditVC.closeView()
        }
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        self.contactAddEditVC.setLocation(latitude: latitude, longitude: longitude)
    }
}
