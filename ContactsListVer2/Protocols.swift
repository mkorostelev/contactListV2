//
//  ContactsList.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/17/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

protocol ContactsListProtocol {
    var contactList : ContactsList? {get set}
}

protocol ContactProtocol {
    var contact : Contact? {get set}
}
