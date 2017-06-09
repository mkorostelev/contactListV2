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
    
    @IBOutlet weak var phoneNumberCenter: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberOutletCenter: NSLayoutConstraint!
    
    @IBOutlet weak var emailCenter: NSLayoutConstraint!
    
    @IBOutlet weak var emailOutletCenter: NSLayoutConstraint!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberCenter.constant -= view.bounds.width
        
        phoneNumberOutletCenter.constant -= view.bounds.width
        
        emailCenter.constant -= view.bounds.width
        
        emailOutletCenter.constant -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.phoneNumberCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.phoneNumberOutletCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.emailCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.emailOutletCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
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
