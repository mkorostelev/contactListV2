//
//  ContactListTVCPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/31/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactListTVCPresenterProtocol: class {
    init(contactsListTVC: ContactListTVCProtocol, contactList: ContactsList?)
    
    var router: ContactListTVCRouterProtocol! { get set }
    
    var numberOfSections: Int { get }
    
    var numberOfRowsInSection: Int { get }
    
    var contactList: ContactsList? { get }
    
    var selectedContact: Contact? { get }
    
    func configureCell(_ cell: ContactsTVCell, forRow row: Int)
    
    func viewDidLoad()
    
    func changeSortMethod()
    
    func deleteContactForRow(_ row: Int)
    
    func selectContactForRow(_ row: Int)
    
    func setViewBackButtonTitle(_ title: String)
    
    func setViewIsEditing(_ value: Bool)
}

class ContactListTVCPresenter: ContactListTVCPresenterProtocol {
    unowned let contactsListTVC: ContactListTVCProtocol
    
    var router: ContactListTVCRouterProtocol!
    
    let contactList: ContactsList?
    
    var contactListArray = [Contact]()
    
    var selectedContact: Contact?
    
    private var currentSortField: AdditionalData.SortFields.Values = SaveLoadData.getUsersDefaultSortMethod() {
        didSet {
            SaveLoadData.setUsersDefaultSortMethod(currentSortField)
            
            Notifications.postChangedSortField()
        }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRowsInSection: Int {
        return contactListArray.count
    }
    
    required init(contactsListTVC: ContactListTVCProtocol, contactList: ContactsList?) {
        self.contactList = contactList
        
        self.contactsListTVC = contactsListTVC
        
        NotificationCenter.default.addObserver(self, selector: #selector(addContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.addContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.removeContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.updateContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateContactList(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.changedSortFild), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureCell(_ cell: ContactsTVCell, forRow row: Int) {
        let contact = contactListArray[row]
        
        let constraintsConstant = [row % 8, 8 - row % 8].min()! * 10
        
        let presenter = ContactTVCellPresenter(contactsTVCell: cell, contact: contact)
        
        presenter.fillCellByContact(constraintsConstant: constraintsConstant)
    }
    
    func viewDidLoad() {
        self.contactsListTVC.sortMethodSegmentControlSelectedSegmentIndex = currentSortField.rawValue
        
        readContactList()
        
        setAvailability()
    }

    func changeSortMethod() {
        currentSortField = AdditionalData.SortFields.Values(rawValue: self.contactsListTVC.sortMethodSegmentControlSelectedSegmentIndex) ?? .lastName
        
        readContactList()
    }

    func readContactList() {
        if let contactListValue = contactList {
            contactListArray = contactListValue.getList(currentSortField: currentSortField)
        }
    }
    
    func setAvailability() {
        
        if contactListArray.count == 0 {
            self.contactsListTVC.viewBackButtonIsEnabled = false
            
            self.contactsListTVC.viewIsEditing = false
        } else {
            self.contactsListTVC.viewBackButtonIsEnabled = true
        }
        
        self.contactsListTVC.sortMethodSegmentControlIsHidden = contactList?.count ?? 0 <= 1
    }

    func setAvailabilityAndReloadData() {
        readContactList()
        
        setAvailability()

        self.contactsListTVC.reloadData()
    }
    
    func setViewBackButtonTitle(_ title: String) {
        self.contactsListTVC.viewBackButtonTitle = title
    }
    
    func setViewIsEditing(_ value: Bool) {
        self.contactsListTVC.viewIsEditing = value
    }
}

// tableView functions
extension ContactListTVCPresenter {
    func deleteContactForRow(_ row: Int) {
        selectedContact = contactListArray[row]
        
        self.contactsListTVC.presentDeletionAlert(contactFullName: selectedContact?.fullName ?? "Contact") {
            self.contactList?.deleteContact(self.selectedContact!)
        }
    }
    
    func selectContactForRow(_ row: Int) {
        selectedContact = contactListArray[row]
    }
}

// observers functions
extension ContactListTVCPresenter {
    @objc func updateContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact {
            let oldIndex = contactListArray.index(of: contact)
            
            readContactList()
            
            let newIndex = contactListArray.index(of: contact)
            
            if let newIndexValue = newIndex, let oldIndexValue = oldIndex {
                self.contactsListTVC.moveRow(at: oldIndexValue, to: newIndexValue)
            }
        }
    }
    
    @objc func deleteContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact {
            let index = contactListArray.index(of: contact)
            
            if let indexValue = index {
                // delete cell for contact
                readContactList()
                
                self.contactsListTVC.deleteRow(at: indexValue)
            }
        }
        
        self.setAvailability()
    }
    
    @objc func addContact(_ notification: NSNotification) {
        readContactList()
        
        if let contact = notification.userInfo?["contact"] as? Contact {
            let index = contactListArray.index(of: contact)
            
            if let indexValue = index {
                // add cell for contact
                self.contactsListTVC.insertRow(at: indexValue)
            }
        }
        
        self.setAvailability()
    }
    
    @objc func updateContactList(_ notification: NSNotification) {
        self.setAvailabilityAndReloadData()
    }
}
