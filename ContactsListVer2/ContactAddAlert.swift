//
//  ContactAddAlertController.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/9/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddAlert: NSObject, UITextFieldDelegate {
    var alertController: UIAlertController? = nil
    
    var presenter: ContactAddAlertPresenterProtocol!
    
    var phoneNumberTF: UITextField?
    
    var emailTF: UITextField?
    
    var firstNameTF: UITextField?
    
    var lastNameTF: UITextField?
    
    var okAlertAction: UIAlertAction?
    
    var okAlertActionIsEnabled: Bool {
        get {
            return self.okAlertAction?.isEnabled ?? false
        }
        
        set {
            self.okAlertAction?.isEnabled = newValue
        }
    }
    
    var firstName: String {
        get {
            return firstNameTF?.text ?? ""
        }
        
        set {
            firstNameTF?.text = newValue
        }
    }
    
    var lastName: String {
        get {
            return lastNameTF?.text ?? ""
        }
        
        set {
            lastNameTF?.text = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return phoneNumberTF?.text ?? ""
        }
        
        set {
            phoneNumberTF?.text = newValue
        }
    }
    
    var email: String {
        get {
            return emailTF?.text ?? ""
        }
        
        set {
            emailTF?.text = newValue
        }
    }
    
    func getAlertController() -> UIAlertController{
        
        if alertController == nil {
            let alertController = UIAlertController(title: "New contact", message: "", preferredStyle: .alert)
            
            alertController.addTextField { (firstName : UITextField) -> Void in
                firstName.placeholder = "First Name"
                
                firstName.delegate = self
                
                self.firstNameTF = firstName
            }
            
            alertController.addTextField { (lastName : UITextField) -> Void in
                lastName.placeholder = "Last Name"
                
                lastName.delegate = self
                
                self.lastNameTF = lastName
            }
            
            alertController.addTextField { (phoneNumber : UITextField) -> Void in
                phoneNumber.placeholder = "Phone Number"
                
                phoneNumber.delegate = self
                
                self.phoneNumberTF = phoneNumber
            }
            
            alertController.addTextField { (email : UITextField) -> Void in
                email.placeholder = "Email"
                
                email.delegate = self
                
                self.emailTF = email
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            
            self.okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
                self.presenter?.checkAndSaveContactFromAlert(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email)
            }
            
            self.okAlertActionIsEnabled = false
            
            alertController.addAction(cancelAction)
            
            alertController.addAction(self.okAlertAction!)
            
            self.alertController = alertController
        }
        
        return self.alertController!
    }
    
    var allInputedText: String {
        return "\(self.firstName)\(self.lastName)\(self.phoneNumber)\(self.email)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        var emailIsValid = true
        
        let currentText = textField.text ?? ""
        
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == self.phoneNumberTF {
            result = DataValidators.validatePhoneNumberInput(value: string)
        } else if textField == self.emailTF {
            let backgroundColor: UIColor
            
            if DataValidators.validateEmail(value: prospectiveText) || prospectiveText.isEmpty {
                backgroundColor = .clear
            } else {
                backgroundColor = .red
                
                emailIsValid = false
                
                self.okAlertActionIsEnabled = false
            }
            textField.backgroundColor = backgroundColor
        }
        
        if result && emailIsValid {
            presenter.checkEnabledOfSaveButton(allInputedText: self.allInputedText, notInOutletString: string, range: range)
        }
        
        return result
    }
}
