//
//  ContactAddEditRouter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/15/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//
import UIKit

protocol ContactAddEditRouterProtocol {
    init(contactAddEditPresenter: ContactAddEditPresenter)
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class ContactAddEditRouter: ContactAddEditRouterProtocol {
    unowned let contactAddEditPresenter: ContactAddEditPresenter
    
    required init(contactAddEditPresenter: ContactAddEditPresenter) {
        self.contactAddEditPresenter = contactAddEditPresenter
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactsLocation" {
            if let toViewController = segue.destination as? ContactsLocationVC {
                let (fullName, phoneNumber, latitude, longitude) = self.contactAddEditPresenter.getLocationInfo()
                
                let presenter = ContactsLocationPresenter(
                    contactsLocationVC: toViewController,
                    contactAddEditPresenter: self.contactAddEditPresenter,
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    latitude: latitude,
                    longitude: longitude
                )
                
                toViewController.presenter = presenter
            }
        }
    }
}
