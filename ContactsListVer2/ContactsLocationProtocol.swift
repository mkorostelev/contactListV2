//
//  ContactsLocationProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/14/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactsLocationProtocol: class{
    func fillDataFromContact(fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?)
}


