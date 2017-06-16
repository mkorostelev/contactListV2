//
//  ContactListTVCRouter.swift
//  ContactsListVer2
//
//  Created by Admin on 6/3/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

protocol ContactListTVCRouterProtocol: ViewRouterProtocol {
    init (contactListTVCPresenter: ContactListTVCPresenterProtocol, navigationController: UINavigationController)
    
    func shouldPerformSegue(withIdentifier identifier: String?) -> Bool
    
    func showViewContact()
}

class ContactListTVCRouter: ContactListTVCRouterProtocol {
    unowned let contactListTVCPresenter: ContactListTVCPresenterProtocol
    
    unowned let navigationController: UINavigationController
    
    required init(contactListTVCPresenter: ContactListTVCPresenterProtocol, navigationController: UINavigationController) {
        self.contactListTVCPresenter = contactListTVCPresenter
        
        self.navigationController = navigationController
    }
        
    func shouldPerformSegue(withIdentifier identifier: String?) -> Bool{
        if identifier == "addContact" && Constants.Settings.useAlertControllerForUserAdd { 
            let contactAddAlert = self.contactListTVCPresenter.getContactAddAlert()

            let alertController = contactAddAlert.getAlertController()

            self.navigationController.present(alertController, animated: true)
            
            return false
        } else if identifier == "viewContact" && Constants.Settings.viewContactViaSecondClick {
            return false
        }
        return true
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
                
                let router = ContactAddEditRouter(contactAddEditPresenter: presenter, navigationController: self.navigationController)
                
                presenter.router = router
                
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
                    
                    let router = ContactViewRouter(contactViewPresenter: presenter, navigationController: self.navigationController)
                    
                    presenter.router = router
                    
                    toViewController.presenter = presenter
                    
                    backButtonTitle = " "
                }
            }
        }
        
        self.contactListTVCPresenter.setViewBackButtonTitle(backButtonTitle)
    }
    
    func showViewContact() {
        self.contactListTVCPresenter.setViewBackButtonTitle(" ")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "ContactView", bundle:nil)
        
        let toViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewVC") as! ContactViewVC
        
        let presenter = ContactViewPresenter(
            contactViewVC: toViewController,
            contactList: self.contactListTVCPresenter.contactList,
            contactUuid: self.contactListTVCPresenter.selectedContact?.uuid
        )
        
        let router = ContactViewRouter(contactViewPresenter: presenter, navigationController: self.navigationController)
        
        presenter.router = router
        
        toViewController.presenter = presenter
        
        self.navigationController.pushViewController(toViewController, animated: true)
    }
}
