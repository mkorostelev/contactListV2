//
//  ContactsTableViewCell.swift
//  ContactsList
//
//  Created by Admin on 5/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ContactsTVCell: UITableViewCell, ContactTVCellProtocol {
    var presenter: ContactTVCellPresenter!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstNameToLastName: NSLayoutConstraint!
    
    @IBOutlet weak var lastNameToPhoneNumber: NSLayoutConstraint!
    
    @IBOutlet weak var firstNameToPhoneNumber: NSLayoutConstraint!
    
    @IBOutlet weak var detailInfoButton: UISwitch!
    
    var fullNameText = ""
    
    var firstNameText = ""
    
    @IBAction func detailInfoValueChanged(_ sender: UISwitch) {
        showDetailInfo(updateTableView: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showDetailInfo(updateTableView: Bool = false) {
        let value = detailInfoButton.isOn
        
        presenter.showDetailInfo = value
        
        email.isHidden = !value
        
        lastName.isHidden = value
        
        if value {
            let index = self.fullNameText.index(
                self.fullNameText.startIndex,
                offsetBy: [Constants.SomeDefaults.countOfDisplayedFullNameCharacters, self.fullNameText.characters.count].min()!
            )
            
            self.firstName?.text = self.fullNameText.substring(to: index)
            
            firstNameToPhoneNumber.priority = UILayoutPriorityDefaultHigh + 200
            
            firstNameToLastName.priority = UILayoutPriorityFittingSizeLevel
            
            lastNameToPhoneNumber.priority = UILayoutPriorityFittingSizeLevel
        } else {
            self.firstName?.text = self.firstNameText
            
            firstNameToPhoneNumber.priority = UILayoutPriorityFittingSizeLevel
            
            firstNameToLastName.priority = UILayoutPriorityDefaultHigh + 200
            
            lastNameToPhoneNumber.priority = UILayoutPriorityDefaultHigh + 200
        }
        
        if updateTableView {
            if let tableView = self.superview?.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
                
                if let indexPath = tableView.indexPath(for: self) {
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
}

// ContactTVCellProtocol implementation
extension ContactsTVCell {
    func fillCell(fullName: String, firstName: String, lastName: String, phoneNumber: String, email: String, constraintsConstant: Int) {
        detailInfoButton.isOn = presenter.showDetailInfo
        
        self.fullNameText = fullName
        
        self.firstNameText = firstName
        
        leadingConstraint.constant = CGFloat(constraintsConstant)
        
        self.firstName?.text = firstName
        
        self.lastName?.text = lastName
        
        self.phoneNumber?.text = phoneNumber
        
        self.email?.text = email
        
        showDetailInfo()
    }
}
