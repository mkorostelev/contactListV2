//
//  ContactAddEditProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/30/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactAddEditProtocol: class {
    var phoneNumberTextField: UITextField { get }
    
    var firstNameTextField: UITextField { get }
    
    var lastNameTextField: UITextField { get }
    
    var emailTextField: UITextField { get }
    
    var deleteContactButton: UIButton { get }
    
    var saveContactButton: UIBarButtonItem { get }
}






