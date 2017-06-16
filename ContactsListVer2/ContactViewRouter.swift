//
//  ContactViewRouter.swift
//  ContactsListVer2
//
//  Created by Admin on 6/3/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

protocol ContactViewRouterProtocol: ViewRouterProtocol {
    init(contactViewPresenter: ContactViewPresenterProtocol, navigationController: UINavigationController)
}

class ContactViewRouter: ContactViewRouterProtocol {
    unowned let contactViewPresenter: ContactViewPresenterProtocol
    
    unowned let navigationController: UINavigationController
    
    required init(contactViewPresenter: ContactViewPresenterProtocol, navigationController: UINavigationController) {
        self.contactViewPresenter = contactViewPresenter
        
        self.navigationController = navigationController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let toViewController = segue.destination as? ContactAddEditVC {
                let presenter = ContactAddEditPresenter(
                    contactAddEditVC: toViewController,
                    contactList: contactViewPresenter.contactList,
                    contactUuid: contactViewPresenter.contactUuid)
                
                let router = ContactAddEditRouter(contactAddEditPresenter: presenter, navigationController: self.navigationController)
                
                presenter.router = router
                
                toViewController.presenter = presenter
            }
        }
    }
}
