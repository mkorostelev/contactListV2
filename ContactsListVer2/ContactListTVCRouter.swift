//
//  ContactListTVCRouter.swift
//  ContactsListVer2
//
//  Created by Admin on 6/3/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

protocol ContactListTVCRouterProtocol: ViewRouterProtocol {
    init (contactListTVCPresenter: ContactListTVCPresenterProtocol)
}

class ContactListTVCRouter: ContactListTVCRouterProtocol {
    unowned let contactListTVCPresenter: ContactListTVCPresenterProtocol
    
    required init(contactListTVCPresenter: ContactListTVCPresenterProtocol) {
        self.contactListTVCPresenter = contactListTVCPresenter
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var backButtonTitle = "Cancel"
        
        self.contactListTVCPresenter.setViewIsEditing(false)
        
        if segue.identifier == "addContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                let presenter = ContactAddEditPresenter(
                    contactAddEditVC: toViewController,
                    contactList: contactListTVCPresenter.contactList,
                    contactUuid: nil
                )
                
                toViewController.presenter = presenter
            }
        } else {
            if segue.identifier == "viewContact" {
                if let toViewController = segue.destination as? ContactViewVC {
                    let presenter = ContactViewPresenter(
                        contactViewVC: toViewController,
                        contactList: contactListTVCPresenter.contactList,
                        contactUuid: contactListTVCPresenter.selectedContact?.uuid
                    )
                    
                    let router = ContactViewRouter(contactViewPresenter: presenter)
                    
                    presenter.router = router
                    
                    toViewController.presenter = presenter
                    
                    backButtonTitle = " "
                }
            }
        }
        
        self.contactListTVCPresenter.setViewBackButtonTitle(backButtonTitle)
    }
}
