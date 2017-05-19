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
    
    var selectedContact : Contact?

    @IBOutlet var contactsListTableView: UITableView!
    @IBOutlet weak var changeSortMethodOutlet: UISegmentedControl!
    
    @IBAction func changeSortMethod(_ sender: UISegmentedControl) {
        contactList?.setSortFieldFromIndex(changeSortMethodOutlet.selectedSegmentIndex)
        
        readContactList()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContactList(_:)), name: NSNotification.Name(rawValue: Constants.notificationsNames.addRemoveContact), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContact(_:)), name: NSNotification.Name(rawValue: Constants.notificationsNames.updateContact), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeSortMethodOutlet.selectedSegmentIndex = contactList?.currentSortField.rawValue ?? 0
        
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
        
        if segue.identifier == "addContact" {
            // QUESTION: in next else i can use let, in current - it is forbidden, WHY?
            //if let toViewController = segue.destination as? ContactsListProtocol {
            if var toViewController = segue.destination as? ContactsListProtocol {
                toViewController.contactList = contactList
            }
        } else {
            if segue.identifier == "viewContact" {
                if let toViewController = segue.destination as? ContactViewVC {
                    toViewController.contactList = contactList
                    toViewController.contact = selectedContact
                    
                    self.navigationItem.backBarButtonItem?.title = " "
                }
            }
        }
    }
    
    func updateContactList(_ notification: NSNotification) {
        setAvailabilityAndReloadData()
    }
    
    func updateContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["contact"] as? Contact, let contactListValue = contactList {
            let oldIndex = contactListArray.index(of: contact)
            
            contactListArray = contactListValue.getList()
            
            let newIndex = contactListArray.index(of: contact)
            
            if let newIndexValue = newIndex, let oldIndexValue = oldIndex {
                let indexPathAt = IndexPath(row: oldIndexValue, section: 0)
                
                let indexPathTo = IndexPath(row: newIndexValue, section: 0)
                
                contactsListTableView.moveRow(at: indexPathAt, to: indexPathTo)
                
                if let cell = contactsListTableView.cellForRow(at: indexPathTo) as? ContactsTVCell {
                    cell.fillCellByContact(contact)
                }
            }
        }
    }
    
    func setAvailabilityAndReloadData() {
        readContactList()
        
        setAvailability()
        
        contactsListTableView.reloadData()
    }
    
    private func readContactList() {
        if let contactListValue = contactList {
            contactListArray = contactListValue.getList()
        }
    }
    
    func setAvailability() {
        if contactListArray.count == 0 {
            self.navigationItem.leftBarButtonItem = nil
            // QUESTION: What is wrong?
            contactsListTableView.setEditing(false, animated: false)
        } else {
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
        
        changeSortMethodOutlet.isHidden = contactListArray.count == 0
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
