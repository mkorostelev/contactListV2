//
//  ContactAddEditVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddEditVC: UIViewController, ContactAddEditProtocol {
    var presenter: ContactAddEditPresenterProtocol!
        
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet weak var deleteContactOutlet: UIButton!
    
    @IBOutlet weak var saveContactOutlet: UIBarButtonItem!
    
    var firstNameTextField: UITextField {
        return firstNameOutlet
    }
    
    var lastNameTextField: UITextField {
        return lastNameOutlet
    }
    
    var phoneNumberTextField: UITextField {
        return phoneNumberOutlet
    }
    
    var emailTextField: UITextField {
        return emailOutlet
    }
    
    var deleteContactButton: UIButton {
        return deleteContactOutlet
    }
    
    var saveContactButton: UIBarButtonItem {
        return saveContactOutlet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        presenter.checkSaveContact()
    }
    @IBAction func deleteContact(_ sender: UIButton) {
        presenter.deleteContact()
    }
}
