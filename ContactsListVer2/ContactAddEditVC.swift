//
//  ContactAddEditVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddEditVC: UIViewController, UITextFieldDelegate, ContactAddEditProtocol {
    var presenter: ContactAddEditPresenterProtocol!
        
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet weak var deleteContactOutlet: UIButton!
    
    @IBOutlet weak var saveContactOutlet: UIBarButtonItem!
    
    var firstName: String {
        get {
            return firstNameOutlet?.text ?? ""
        }
        
        set {
            firstNameOutlet?.text = newValue
        }
    }
    
    var lastName: String {
        get {
            return lastNameOutlet?.text ?? ""
        }
        
        set {
            lastNameOutlet?.text = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return phoneNumberOutlet?.text ?? ""
        }
        
        set {
            phoneNumberOutlet?.text = newValue
        }
    }
    
    var email: String {
        get {
            return emailOutlet?.text ?? ""
        }
        
        set {
            emailOutlet?.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()

        presenter.viewDidLoad()
        
        presenter.checkEnabledOfSaveButton(allInputedText: self.allInputedText, notInOutletString: "", range: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setDelegates() {
        firstNameOutlet.delegate = self
        
        lastNameOutlet.delegate = self
        
        phoneNumberOutlet.delegate = self
        
        emailOutlet.delegate = self
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        presenter.validateAndSaveContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
    }
    
    @IBAction func deleteContact(_ sender: UIButton) {
        presenter.deleteContact()
    }
}

extension ContactAddEditVC {
    var allInputedText: String {
        return "\(self.firstName)\(self.lastName)\(self.phoneNumber)\(self.email)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.phoneNumberOutlet {
            result = DataValidators.validatePhoneNumberInput(value: string)
        }
        
        if result {
            presenter.checkEnabledOfSaveButton(allInputedText: self.allInputedText, notInOutletString: string, range: range)
        }
        
        return result
    }
}

extension ContactAddEditVC {
    var deleteContactButtonIsHidden: Bool {
        get {
            return deleteContactOutlet.isHidden
        }
        
        set {
            deleteContactOutlet.isHidden = newValue
        }
    }
    
    var saveButtonIsEnabled: Bool {
        get {
            return saveContactOutlet.isEnabled
        }
        
        set {
            saveContactOutlet.isEnabled = newValue
        }
    }
    
    func fillTextFieldsData(firstName: String, lastName: String, phoneNumber: String, email: String) {
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.phoneNumber = phoneNumber
        
        self.email = email
    }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getDeleteContactAlert(contactFullName: contactFullName, deleteAction: deleteAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentEmailValidationAlert(saveAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getEmailValidationAlert(email: self.email, saveAction: saveAction)
        
        self.present(alertController, animated: true)
    }
    
    func closeView() {
        self.performSegueToReturnBack()
    }
}
