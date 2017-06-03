//
//  ContactViewRouter.swift
//  ContactsListVer2
//
//  Created by Admin on 6/3/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

protocol ContactViewRouterProtocol: ViewRouterProtocol {
    init(contactViewPresenter: ContactViewPresenterProtocol)
}

class ContactViewRouter: ContactViewRouterProtocol {
    unowned let contactViewPresenter: ContactViewPresenterProtocol
    
    required init(contactViewPresenter: ContactViewPresenterProtocol) {
        self.contactViewPresenter = contactViewPresenter
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                let presenter = ContactAddEditPresenter(
                    contactAddEditVC: toViewController,
                    contactList: contactViewPresenter.contactList,
                    contactUuid: contactViewPresenter.contactUuid)
                
                toViewController.presenter = presenter
            }
        }
    }
}
