//
//  ContactsTableViewCell.swift
//  ContactsList
//
//  Created by Admin on 5/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ContactsTVCell: UITableViewCell, ContactTVCellProtocol {

    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func fillCell(fullName: String, phoneNumber: String) {
        self.fullName?.text = fullName
        
        self.phoneNumber?.text = phoneNumber
    }
}
