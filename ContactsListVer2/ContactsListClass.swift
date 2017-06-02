//
//  ContactsListClass.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

import UIKit

class ContactsList: NSObject, NSCoding {

    enum SortField: Int{
        case firstName
        case lastName
        case phoneNumber
        case email
    }
    
    private var listOfContacts = SaveLoadData.fromDrive()
    {
        didSet {
            self.saveData()
        }
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.contactWasUpdated(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.updateContact), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contactWasUpdated(_ notification: NSNotification) {
        self.saveData()
    }
    
    var count: Int {
        return self.listOfContacts.count
    }
    
    func getList(currentSortField: AdditionalData.SortFields.Values ,searchString: String = "") -> [Contact] {
        let result: [Contact]
        
        let searchStringLowercased = searchString.lowercased().trimmingCharacters(in: .whitespaces)
        
        if searchString == "" {
            result = self.listOfContacts
        } else {
            result = self.listOfContacts.filter({
                (contact: Contact) -> Bool in
                return contact.searchString.range(of: searchStringLowercased) != nil
            })
        }
        
        return result.sorted(by: { isFirstSmallerThanSecond(contact1: $0, contact2: $1, currentSortField: currentSortField) })
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, email: String) {
        if "\(firstName)\(lastName)\(phoneNumber)\(email)" == "" {
            return
        }
        
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        
        self.listOfContacts.append(newContact)
        
        Notifications.postAddContact(newContact)
    }
    
    func getByUuid(_ uuid: String?) -> Contact? {
        var result: Contact? = nil
        
        if let uuidValue = uuid {
            let filteredArray = self.listOfContacts.filter({ $0.uuid == uuidValue })
            
            if filteredArray.count > 0 {
                result = filteredArray[0]
            }
        }
        
        return result
    }
    
    func deleteContact(_ contact: Contact) {
        if contact.uuid != "" {
            if let removeIndex = self.listOfContacts.index(where: { $0.uuid == contact.uuid }) {
                self.listOfContacts.remove(at: removeIndex)
                Notifications.postRemoveContact(contact)
            }
        }
    }
    
    required init(coder decoder: NSCoder) {
        self.listOfContacts = decoder.decodeObject(forKey: "listOfContacts") as? [Contact] ?? [Contact]()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.listOfContacts, forKey: "listOfContacts")
    }
    
    func saveData() {
        SaveLoadData.toDrive(self.listOfContacts)
    }
    
    private func isFirstSmallerThanSecond(contact1: Contact, contact2: Contact, currentSortField: AdditionalData.SortFields.Values) -> Bool {
        let firstCompareResult: ComparisonResult
        
        let secondCompareResult: ComparisonResult
        
        switch currentSortField {
        case .firstName:
            firstCompareResult = contact1.firstName.localizedCaseInsensitiveCompare(contact2.firstName)
            
            secondCompareResult = contact1.lastName.localizedCaseInsensitiveCompare(contact2.lastName)
        case .lastName:
            firstCompareResult = contact1.lastName.localizedCaseInsensitiveCompare(contact2.lastName)
            
            secondCompareResult = contact1.firstName.localizedCaseInsensitiveCompare(contact2.firstName)
        case .phoneNumber:
            firstCompareResult = contact1.phoneNumber.localizedCaseInsensitiveCompare(contact2.phoneNumber)
            
            secondCompareResult = contact1.fullName.localizedCaseInsensitiveCompare(contact2.fullName)
        case .email:
            firstCompareResult = contact1.email.localizedCaseInsensitiveCompare(contact2.email)
            
            secondCompareResult = contact1.fullName.localizedCaseInsensitiveCompare(contact2.fullName)
        }
        
        if firstCompareResult == .orderedSame {
            return secondCompareResult == .orderedAscending
        } else {
            return firstCompareResult == .orderedAscending
        }
    }
}
