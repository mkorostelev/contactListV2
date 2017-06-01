//
//  ContactsListTVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/17/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactsListTVC: UITableViewController, ContactListTVCProtocol {
    var presenter: ContactListTVCPresenterProtocol!
    
    var contactsListTV: UITableView {
        return contactsListTableView
    }
    
    var sortMethodSegmentControl: UISegmentedControl {
        return changeSortMethodOutlet
    }
    
    var contactList: ContactsList?

    var contactListArray = [Contact]()
    
    var selectedContact: Contact?

    var currentSortField: AdditionalData.SortFields.Values = SaveLoadData.getUsersDefaultSortMethod()
    {
        didSet {
            SaveLoadData.setUsersDefaultSortMethod(self.currentSortField)
            
            Notifications.postChangedSortField()
        }
    }
    
    @IBOutlet var contactsListTableView: UITableView!
    
    @IBOutlet weak var changeSortMethodOutlet: UISegmentedControl!
    
    @IBAction func changeSortMethod(_ sender: UISegmentedControl) {
        presenter.changeSortMethod()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTVCell.reuseIdentifier, for: indexPath) as? ContactsTVCell {
            presenter.configureCell(cell, forRow: indexPath.row)
        
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteContactForRow(indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        presenter.selectContactForRow(indexPath.row)
        
        return indexPath
    }
}
