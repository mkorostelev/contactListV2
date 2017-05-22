//
//  AdditionalDataStruct.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/22/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

struct AdditionalData {
    struct SortFields {
        enum Values: Int{
            case firstName
            case lastName
            case phoneNumber
            case email
        }
    }
}
