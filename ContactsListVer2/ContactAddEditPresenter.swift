//
//  ContactAddEditPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactAddEditPresenterProtocol: class, ContactAddBaseProtocol {
    init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?)
    
    func onViewDidLoad()
    
    func deleteContact()
    
    func setLocation(latitude: Double?, longitude: Double?, address: String?)
    
    var router: ContactAddEditRouterProtocol! { get set }
    
    func getLocationInfo() -> (fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?)
}

class ContactAddEditPresenter: ContactAddEditPresenterProtocol {
    unowned var connectedController: ControllerWithSaveButton

    unowned var connectedController1: ContactAddEditProtocol
    
    var router: ContactAddEditRouterProtocol!
    
    let contactList: ContactsList?
    
    let contactUuid: String?
    
    private let contact: Contact?
    
    required init(contactAddEditVC: ContactAddEditProtocol, contactList: ContactsList?, contactUuid: String?) {
        self.connectedController1 = contactAddEditVC
        
        self.connectedController = contactAddEditVC
        
        self.contactList = contactList
        
        self.contactUuid = contactUuid
        
        self.contact = contactList?.getByUuid(contactUuid)
    }
    
    func onViewDidLoad() {
        if let contactValue = self.contact {
            self.connectedController1.fillTextFieldsData(
                firstName: contactValue.firstName,
                lastName: contactValue.lastName,
                phoneNumber: contactValue.phoneNumber,
                email: contactValue.email,
                photo: contactValue.photo,
                latitude: contactValue.latitude,
                longitude: contactValue.longitude
            )
        } else {
            self.connectedController1.deleteContactButtonIsHidden = true
            
            self.connectedController1.fillContactsLocation()
        }
    }
    
    func validateAndSaveContact(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?) {
        if email.isEmpty || DataValidators.validateEmail(value: email) {
            self.saveContactConfirmed(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: latitude, longitude: longitude)
        } else {
            self.connectedController1.presentEmailValidationAlert {
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
            
            self.connectedController1.closeViewAndGoBack()
        } else {
            // add new contact
            contactList?.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: latitude, longitude: longitude)
            
            self.connectedController1.closeViewAndGoToRoot()
        }
    }
    
    func deleteContact() {
        self.connectedController1.presentDeletionAlert(contactFullName: contact?.fullName ?? "Contact") {
            self.deleteContactConfirmed()
        }
    }
    
    private func deleteContactConfirmed() {
        if let contact = self.contact {
            contactList?.deleteContact(contact)
            
            self.connectedController1.closeViewAndGoToRoot()
        }
    }
    
    func setLocation(latitude: Double?, longitude: Double?, address: String?) {
        self.connectedController1.setLocation(latitude: latitude, longitude: longitude, address: address)
    }
    
    func getLocationInfo() -> (fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        return self.connectedController1.getLocationInfo()
    }
}
