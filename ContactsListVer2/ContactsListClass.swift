//
//  ContactsListClass.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

import UIKit

class ContactsList : NSObject, NSCoding {

    enum SortField : Int{
        case firstName
        case lastName
        case phoneNumber
        case email
    }
    
    private var listOfContacts = SaveLoadCheckData.fromDrive()
    {
        didSet {
            self.saveData()
        }
    }
    
    override init() {
        super.init()
        
        if let savedSortField = SaveLoadCheckData.getUsersDefaultSortMethod() {
            self.currentSortField = savedSortField
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.contactWasUpdated(_:)), name: NSNotification.Name(rawValue: Constants.notificationsNames.updateContact), object: nil)
    }
    
    @objc private func contactWasUpdated(_ notification: NSNotification) {
        self.saveData()
    }
    
    var count : Int {
        return self.listOfContacts.count
    }
    
    var currentSortField : SortField = .lastName
    {
        didSet {
            SaveLoadCheckData.setUsersDefaultSortMethod(self.currentSortField)
            
            Notifications.postChangedSortField()
        }
    }
    
    public func setSortFieldFromIndex(_ index : Int) {
        if let newSortFieldName = SortField(rawValue: index) {
            self.currentSortField = newSortFieldName
        }
    }
    
    func getList(searchString : String = "") -> [Contact] {
        let result : [Contact]
        
        let searchStringLowercased = searchString.lowercased().trimmingCharacters(in: .whitespaces)
        
        if searchString == "" {
            result = self.listOfContacts
        } else {
            result = self.listOfContacts.filter({
                (contact : Contact) -> Bool in
                return contact.searchString.range(of: searchStringLowercased) != nil
            })
        }
        
        return result.sorted(by: isFirstSmallerThanSecond)
    }
    
    func addContact(firstName : String, lastName : String, phoneNumber : String, email : String) {
        if "\(firstName)\(lastName)\(phoneNumber)\(email)" == "" {
            return
        }
        
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        
        self.listOfContacts.append(newContact)
        
        Notifications.postAddContact(newContact)
    }
    
    func getByUuid(_ uuid : String) -> Contact? {
        let filteredArray = self.listOfContacts.filter({ $0.uuid == uuid })
        
        let result : Contact?
        
        if filteredArray.count > 0 {
            result = filteredArray[0]
        } else {
            result = nil
        }
        
        return result
    }
    
    func deleteContact(_ contact : Contact) {
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
        SaveLoadCheckData.toDrive(self.listOfContacts)
    }
    
    private func isFirstSmallerThanSecond(contact1 : Contact, contact2 : Contact) -> Bool {
        let firstCompareResult : ComparisonResult
        
        let secondCompareResult : ComparisonResult
        
        switch self.currentSortField {
        case .firstName:
            firstCompareResult = contact1.firstName.compare(contact2.firstName)
            secondCompareResult = contact1.lastName.compare(contact2.lastName)
        case .lastName:
            firstCompareResult = contact1.lastName.compare(contact2.lastName)
            secondCompareResult = contact1.firstName.compare(contact2.firstName)
        case .phoneNumber:
            firstCompareResult = contact1.phoneNumber.compare(contact2.phoneNumber)
            secondCompareResult = contact1.fullName.compare(contact2.fullName)
        case .email:
            firstCompareResult = contact1.email.compare(contact2.email)
            secondCompareResult = contact1.fullName.compare(contact2.fullName)
        }
        
        if firstCompareResult == .orderedSame {
            return secondCompareResult == .orderedAscending
        } else {
            return firstCompareResult == .orderedAscending
        }
    }
}
















