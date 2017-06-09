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
            let alertController = UIAlertController(title: "New contact", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField { (firstName : UITextField) -> Void in
                firstName.placeholder = "First Name"
            }
            alertController.addTextField { (lastName : UITextField) -> Void in
                lastName.placeholder = "Last Name"
            }
            alertController.addTextField { (phoneNumber : UITextField) -> Void in
                phoneNumber.placeholder = "Phone Number"
            }
            alertController.addTextField { (email : UITextField) -> Void in
                email.placeholder = "Email"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                debugPrint("Try")
            }
            
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            if let presenter = self.contactListTVCPresenter as? ContactListTVCPresenter {
                if let view = presenter.contactsListTVC as? UITableViewController {
                    view.present(alertController, animated: true, completion: nil)
                }
            }
            
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
                
                toViewController.presenter = presenter
            }
        }
        else {
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
    
    func showViewContact() {
//        self.contactListTVCPresenter.setViewBackButtonTitle(backButtonTitle)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "ContactView", bundle:nil)
        
        let toViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewVC") as! ContactViewVC
        
        let presenter = ContactViewPresenter(
            contactViewVC: toViewController,
            contactList: self.contactListTVCPresenter.contactList,
            contactUuid: self.contactListTVCPresenter.selectedContact?.uuid
        )
        
        let router = ContactViewRouter(contactViewPresenter: presenter)
        
        presenter.router = router
        
        toViewController.presenter = presenter
        
        self.navigationController.pushViewController(toViewController, animated: true)
    }
}
