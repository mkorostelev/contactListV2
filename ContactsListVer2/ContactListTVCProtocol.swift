//
//  ContactListTVCProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/31/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactListTVCProtocol: class {
    var contactsListTV: UITableView { get }
    
    var sortMethodSegmentControl: UISegmentedControl { get }
}
