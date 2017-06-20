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
        
        contactsListTableView.rowHeight = UITableViewAutomaticDimension
        
        contactsListTableView.estimatedRowHeight = 88
        	
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
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        return presenter.router.shouldPerformSegue(withIdentifier: identifier)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Constants.Settings.viewContactViaSecondClick{
            self.presenter.tableViewdidSelectRow()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animateTable()
    }
}

//animation
extension ContactsListTVC {
    func animateTable() {
        contactsListTableView.reloadData()
        
        let cells = contactsListTableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

//ContactListTVCProtocol
extension ContactsListTVC {
    var viewIsEditing: Bool {
        get {
            return self.isEditing
        }
        
        set {
            self.isEditing = newValue
        }
    }
    
    var viewBackButtonIsEnabled: Bool {
        get {
            return self.navigationItem.leftBarButtonItem == self.editButtonItem
        }
        
        set {
            if newValue {
                self.navigationItem.leftBarButtonItem = self.editButtonItem
            } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    var sortMethodSegmentControlIsHidden: Bool {
        get {
            return self.changeSortMethodOutlet.isHidden
        }
        
        set {
            self.changeSortMethodOutlet.isHidden = newValue
        }
    }
    
    var sortMethodSegmentControlSelectedSegmentIndex: Int {
        get {
            return self.changeSortMethodOutlet.selectedSegmentIndex
        }
        
        set {
            self.changeSortMethodOutlet.selectedSegmentIndex = newValue
        }
    }
    
    var viewBackButtonTitle: String {
        get {
            return self.navigationItem.backBarButtonItem?.title ?? ""
        }
        
        set {
            self.navigationItem.backBarButtonItem?.title = newValue
        }
    }
    
    func moveRow(at rowAt: Int, to rowTo: Int) {
        let indexPathAt = IndexPath(row: rowAt, section: 0)
        
        let indexPathTo = IndexPath(row: rowTo, section: 0)
        
        self.contactsListTableView.moveRow(at: indexPathAt, to: indexPathTo)
        
        self.contactsListTableView.reloadRows(at: [indexPathTo], with: .bottom)
    }
    
    func deleteRow(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        self.contactsListTableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func insertRow(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        self.contactsListTableView.insertRows(at: [indexPath], with: .top)
    }
    
    func reloadData() {
        if self.contactsListTableView != nil {
            self.contactsListTableView.reloadData()
        }
    }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getDeleteContactAlert(contactFullName: contactFullName, deleteAction: deleteAction)
        
        self.present(alertController, animated: true)
    }
    
    func updateListStartsFromRowToRow(rowFrom: Int, rowTo: Int) {
        let arrayOfRowsNumbers = Array(rowFrom...rowTo)
        
        let arrayOfIndexesPaths = arrayOfRowsNumbers.map( { IndexPath(row: $0, section: 0) } )
        
        self.contactsListTableView.reloadRows(at: arrayOfIndexesPaths, with: .bottom)
    }
}
