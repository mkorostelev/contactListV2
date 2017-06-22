//
//  ContactsLocationTVPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/14/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactsLocationPresenterProtocol: class {
    init(contactsLocationVC: ContactsLocationProtocol, contactAddEditPresenter: ContactAddEditPresenterProtocol, fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?)
    
    func setLocation(latitude: Double?, longitude: Double?, address: String?)
    
    func onViewDidLoad()
}

class ContactsLocationPresenter: ContactsLocationPresenterProtocol {
    unowned let contactsLocationVC: ContactsLocationProtocol
    
    unowned let contactAddEditPresenter: ContactAddEditPresenterProtocol
    
    let fullName: String
    
    let phoneNumber: String
    
    var latitude: Double?
    
    var longitude: Double?
    
    required init(contactsLocationVC: ContactsLocationProtocol, contactAddEditPresenter: ContactAddEditPresenterProtocol, fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        self.contactsLocationVC = contactsLocationVC
        
        self.contactAddEditPresenter = contactAddEditPresenter
        
        self.fullName = fullName
        
        self.phoneNumber = phoneNumber
        
        self.latitude = latitude
        
        self.longitude = longitude
    }

    func setLocation(latitude: Double?, longitude: Double?, address: String?) {
        self.contactAddEditPresenter.setLocation(latitude: latitude, longitude: longitude, address: address)
    }
    
    func onViewDidLoad() {
        self.contactsLocationVC.fillDataFromContact(fullName: self.fullName, phoneNumber: self.phoneNumber, latitude: self.latitude, longitude: self.longitude)
    }
}
