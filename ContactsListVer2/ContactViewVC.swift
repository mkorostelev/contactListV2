//
//  ContactViewVC.swift
//  ContactsListVer2
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactViewVC: UIViewController, ContactViewProtocol {
    var presenter: ContactViewPresenterProtocol!
    
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}

// ContactViewProtocol implementation
extension ContactViewVC {
    func fillDataFromContact(title: String, phoneNumber: String, email: String) {
        self.navigationItem.title = title
        
        phoneNumberOutlet?.text = phoneNumber
        
        emailOutlet?.text = email
    }
}
