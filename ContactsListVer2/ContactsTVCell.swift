//
//  ContactsTableViewCell.swift
//  ContactsList
//
//  Created by Admin on 5/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ContactsTVCell: UITableViewCell, ContactTVCellProtocol {
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// ContactTVCellProtocol implementation
extension ContactsTVCell {
    func fillCell(fullName: String, firstName: String, lastName: String, phoneNumber: String, email: String, constraintsConstant: Int) {
        leadingConstraint.constant = CGFloat(constraintsConstant)
        
        self.firstName?.text = firstName
        
        self.lastName?.text = lastName
        
        self.phoneNumber?.text = phoneNumber
        
        self.email?.text = email
    }
}
