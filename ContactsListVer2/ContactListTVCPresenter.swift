//
//  ContactListTVCPresenter.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/31/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

protocol ContactListTVCPresenterProtocol {
    init(view: ContactListTVCProtocol, contactList: ContactsList?)
    
    var numberOfSections: Int { get }
    
    var numberOfRowsInSection: Int { get }
    
    func configureCell(_ cell: ContactsTVCell, forRow row: Int)
    
    func viewDidLoad()
    
    func changeSortMethod()
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    func deleteContactForRow(_ row: Int)
    
    func selectContactForRow(_ row: Int)
}

class ContactListTVCPresenter: ContactListTVCPresenterProtocol {
    unowned let view: ContactListTVCProtocol
    
    let contactList: ContactsList?
    
    var contactListArray = [Contact]()
    
    var selectedContact: Contact?
    
    var currentSortField: AdditionalData.SortFields.Values = SaveLoadCheckData.getUsersDefaultSortMethod()
    {
        didSet {
            SaveLoadCheckData.setUsersDefaultSortMethod(currentSortField)
            
            Notifications.postChangedSortField()
        }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRowsInSection: Int {
        return contactListArray.count
    }
    
    required init(view: ContactListTVCProtocol, contactList: ContactsList?) {
        self.contactList = contactList
        
        self.view = view
        
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
        
        let presenter = ContactTVCellPresenter(view: cell, contact: contact)
        
        presenter.fillCellByContact()
    }
    
    func viewDidLoad() {
        view.sortMethodSegmentControl.selectedSegmentIndex = currentSortField.rawValue
        
        readContactList()
        
        setAvailability()
    }

    func changeSortMethod() {
        currentSortField = AdditionalData.SortFields.Values(rawValue: view.sortMethodSegmentControl.selectedSegmentIndex) ?? .lastName
        
        readContactList()
    }

    internal func readContactList() {
        if let contactListValue = contactList {
            contactListArray = contactListValue.getList(currentSortField: currentSortField)
        }
    }
    
    func setAvailability() {
        if let view = view as? UITableViewController {
            if contactListArray.count == 0 {
                view.navigationItem.leftBarButtonItem = nil
                
                view.isEditing = false
            } else {
                view.navigationItem.leftBarButtonItem = view.editButtonItem
            }
        }
    
        view.sortMethodSegmentControl.isHidden = contactList?.count ?? 0 <= 1
    }

    func setAvailabilityAndReloadData() {
        readContactList()
        
        setAvailability()
        
        view.contactsListTV.reloadData()
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var backButtonTitle = "Cancel"
        
        if let view = view as? UITableViewController {
            view.isEditing = false
            
            if segue.identifier == "addContact" {
                if let toViewController = segue.destination as? ContactAddEditVC {
                    let presenter = ContactAddEditPresenter(view: toViewController, contactList: contactList, contactUuid: nil)
                    
                    toViewController.presenter = presenter
                }
            } else {
                if segue.identifier == "viewContact" {
                    if let toViewController = segue.destination as? ContactViewVC {
                        
                        let presenter = ContactViewPresenter(view: toViewController, contactList: contactList, contactUuid: selectedContact?.uuid)
                        
                        toViewController.presenter = presenter
                        
                        backButtonTitle = " "
                    }
                }
            }
            
            view.navigationItem.backBarButtonItem?.title = backButtonTitle
        }
    }
}

// tableView functions
extension ContactListTVCPresenter {
    func deleteContactForRow(_ row: Int) {
        contactList?.deleteContact(contactListArray[row])
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
                let indexPathAt = IndexPath(row: oldIndexValue, section: 0)
                
                let indexPathTo = IndexPath(row: newIndexValue, section: 0)
                
                self.view.contactsListTV.moveRow(at: indexPathAt, to: indexPathTo)
                
                self.view.contactsListTV.reloadRows(at: [indexPathTo], with: .bottom)
            }
        }
    }
    
    @objc func deleteContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact {
            let index = contactListArray.index(of: contact)
            
            if let indexValue = index {
                // delete cell for contact
                let indexPath = IndexPath(row: indexValue, section: 0)
                
                readContactList()
                
                self.view.contactsListTV.deleteRows(at: [indexPath], with: .top)
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
                let indexPath = IndexPath(row: indexValue, section: 0)
                
                self.view.contactsListTV.insertRows(at: [indexPath], with: .top)
            }
        }
        
        self.setAvailability()
    }
    
    @objc func updateContactList(_ notification: NSNotification) {
        self.setAvailabilityAndReloadData()
    }
}







