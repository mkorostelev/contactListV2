//
//  ContactsListTVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/17/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactsListTVC: UITableViewController, ContactsListProtocol {
    var contactList: ContactsList?

    var contactListArray = [Contact]()
    
    var selectedContact: Contact?

    var currentSortField: AdditionalData.SortFields.Values = SaveLoadCheckData.getUsersDefaultSortMethod()
    {
        didSet {
            SaveLoadCheckData.setUsersDefaultSortMethod(self.currentSortField)
            
            Notifications.postChangedSortField()
        }
    }
    
    @IBOutlet var contactsListTableView: UITableView!
    @IBOutlet weak var changeSortMethodOutlet: UISegmentedControl!
    
    @IBAction func changeSortMethod(_ sender: UISegmentedControl) {
        currentSortField = AdditionalData.SortFields.Values(rawValue: changeSortMethodOutlet.selectedSegmentIndex) ?? .lastName
        
        readContactList()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.addContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.removeContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContact(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.updateContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContactList(_:)), name: NSNotification.Name(rawValue: Constants.NotificationsNames.changedSortFild), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeSortMethodOutlet.selectedSegmentIndex = currentSortField.rawValue
        
        readContactList()
        
        setAvailability()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTVCell.reuseIdentifier, for: indexPath) as? ContactsTVCell {
            let contact = contactListArray[indexPath.row]
            
            cell.fillCellByContact(contact)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var backButtonTitle = "Cancel"
        
        self.isEditing = false
        
        if segue.identifier == "addContact" {
            if var toViewController = segue.destination as? ContactsListProtocol {
                toViewController.contactList = contactList
            }
        } else {
            if segue.identifier == "viewContact" {
                if let toViewController = segue.destination as? ContactViewVC {
                    toViewController.contactList = contactList
                    toViewController.contactUuid = selectedContact?.uuid
                    
                    backButtonTitle = " "
                }
            }
        }
        
        self.navigationItem.backBarButtonItem?.title = backButtonTitle
    }
    
    func updateContactList(_ notification: NSNotification) {
        setAvailabilityAndReloadData()
    }
    
    func updateContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact {
            let oldIndex = contactListArray.index(of: contact)
            
            readContactList()
            
            let newIndex = contactListArray.index(of: contact)
            
            if let newIndexValue = newIndex, let oldIndexValue = oldIndex {
                let indexPathAt = IndexPath(row: oldIndexValue, section: 0)
                
                let indexPathTo = IndexPath(row: newIndexValue, section: 0)
                
                contactsListTableView.moveRow(at: indexPathAt, to: indexPathTo)
                
                contactsListTableView.reloadRows(at: [indexPathTo], with: .bottom)
            }
        }
    }
    
    func deleteContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact {
            let index = contactListArray.index(of: contact)
            
            if let indexValue = index {
                // delete cell for contact
                let indexPath = IndexPath(row: indexValue, section: 0)
                
                readContactList()
                
                contactsListTableView.deleteRows(at: [indexPath], with: .top)
            }
        }
        
        setAvailability()
    }
    
    func addContact(_ notification: NSNotification) {
        readContactList()
        
        if let contact = notification.userInfo?["contact"] as? Contact {
            let index = contactListArray.index(of: contact)
            
            if let indexValue = index {
                // add cell for contact
                let indexPath = IndexPath(row: indexValue, section: 0)
                
                contactsListTableView.insertRows(at: [indexPath], with: .top)
            }
        }
        
        setAvailability()
    }
    
    func setAvailabilityAndReloadData() {
        readContactList()
        
        setAvailability()
        
        contactsListTableView.reloadData()
    }
    
    private func readContactList() {
        if let contactListValue = contactList {
            contactListArray = contactListValue.getList(currentSortField: currentSortField)
        }
    }
    
    func setAvailability() {
        if contactListArray.count == 0 {
            self.navigationItem.leftBarButtonItem = nil
            
            self.isEditing = false
        } else {
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
        
        changeSortMethodOutlet.isHidden = contactList?.count ?? 0 <= 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactList?.deleteContact(contactListArray[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedContact = contactListArray[indexPath.row]
        
        return indexPath
    }
}
