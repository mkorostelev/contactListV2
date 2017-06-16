//
//  ContactAddEditRouter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/15/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//
import UIKit

protocol ContactAddEditRouterProtocol {
    init(contactAddEditPresenter: ContactAddEditPresenter, navigationController: UINavigationController)
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    func shouldPerformSegue(withIdentifier identifier: String?) -> Bool
}

class ContactAddEditRouter: ContactAddEditRouterProtocol {
    unowned let contactAddEditPresenter: ContactAddEditPresenter
    
    unowned let navigationController: UINavigationController
    
    required init(contactAddEditPresenter: ContactAddEditPresenter, navigationController: UINavigationController) {
        self.contactAddEditPresenter = contactAddEditPresenter
        
        self.navigationController = navigationController
    }
    
    func shouldPerformSegue(withIdentifier identifier: String?) -> Bool{
        if identifier == "contactsLocation" {
            let alertController = self.getLocationAlert(navigationController: navigationController)
            
            navigationController.present(alertController, animated: true)
            
            return false
        }
        return true
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
    
    private func getLocationAlert(navigationController: UINavigationController) -> UIAlertController {
        let (fullName, phoneNumber, latitude, longitude) = self.contactAddEditPresenter.getLocationInfo()
        
        let locationIsFilled = latitude != nil && longitude != nil
        
        var setOrChangeText = "Set location"
        
        if locationIsFilled {
            setOrChangeText = "Change / View"
        }
        
        let alertController = UIAlertController(title: "Contact`s location", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let setOrChangeAction = UIAlertAction(title: setOrChangeText, style: .default) { _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "ContactsLocation", bundle: nil)
            
            let toViewController = storyBoard.instantiateViewController(withIdentifier: "ContactsLocationVC") as! ContactsLocationVC
            
            let presenter = ContactsLocationPresenter(
                contactsLocationVC: toViewController,
                contactAddEditPresenter: self.contactAddEditPresenter,
                fullName: fullName,
                phoneNumber: phoneNumber,
                latitude: latitude,
                longitude: longitude
            )
            
            toViewController.presenter = presenter
            
            navigationController.pushViewController(toViewController, animated: true)
        }
        
        alertController.addAction(setOrChangeAction)
        
        if locationIsFilled {
            let eraseAction = UIAlertAction(title: "Erase", style: .destructive) { _ in
                self.contactAddEditPresenter.setLocation(latitude: nil, longitude: nil)
            }
            
            alertController.addAction(eraseAction)
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
