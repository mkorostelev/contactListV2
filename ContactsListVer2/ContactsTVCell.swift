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
    
    @IBOutlet weak var emailWidth: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberWidth: NSLayoutConstraint!
    
    @IBOutlet weak var photoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var detailInfoButton: UISwitch!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    var fullNameText = ""
    
    var firstNameText = ""
    
    var phoneNumberText = ""
    
    var emailText = ""
    
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
        
        self.configureConstraints(showDetailInfo: value)
        
        if updateTableView {
            if let tableView = self.superview?.superview as? UITableView {
                
                tableView.beginUpdates()
                tableView.endUpdates()
                
                if let indexPath = tableView.indexPath(for: self) {
//                    tableView.reloadRows(at: [indexPath], with: .left)
                    
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
}

// constraints configuration
extension ContactsTVCell {
    private enum Priorities: UILayoutPriority {
        case high = 999
        
        case middle = 750
        
        case low = 10
    }
    
    func configureConstraints(showDetailInfo: Bool) {
        configureFirstName(showDetailInfo: showDetailInfo)
        
        configureEmailAndPhoneNumber(showDetailInfo: showDetailInfo)
        
        configurePhotoSize(showDetailInfo: showDetailInfo)
    }
    
    private func configurePhotoSize(showDetailInfo: Bool) {
        var width: CGFloat = 60
        
        var height: CGFloat = 75
        
        if showDetailInfo {
            width = 40
            
            height = 50
        }
        
        photoWidth.constant = width
        
        photoHeight.constant = height
    }
    
    private func configureFirstName(showDetailInfo: Bool) {
        let firstNameToPhoneNumberPriority: UILayoutPriority
        
        let firstNameToLastNamePriority: UILayoutPriority
        
        let lastNameToPhoneNumberPriority: UILayoutPriority
        
        let firstNameLabelText: String
        
        let firstNameFont: UIFont
        
        if showDetailInfo {
            let index = self.fullNameText.index(
                self.fullNameText.startIndex,
                offsetBy: [Constants.SomeDefaults.countOfDisplayedFullNameCharacters, self.fullNameText.characters.count].min()!
            )
            
            firstNameLabelText = self.fullNameText.substring(to: index)
            
            firstNameToPhoneNumberPriority = Priorities.high.rawValue
            
            firstNameToLastNamePriority = Priorities.low.rawValue
            
            lastNameToPhoneNumberPriority = Priorities.low.rawValue
            
            firstNameFont = UIFont.preferredFont(forTextStyle: .headline)
        } else {
            firstNameLabelText = self.firstNameText
            
            firstNameToPhoneNumberPriority = Priorities.low.rawValue
            
            firstNameToLastNamePriority = Priorities.high.rawValue
            
            lastNameToPhoneNumberPriority = Priorities.high.rawValue
            
            firstNameFont = UIFont.preferredFont(forTextStyle: .body)
        }
        
        self.firstName?.text = firstNameLabelText
        
        firstNameToPhoneNumber.priority = firstNameToPhoneNumberPriority
        
        firstNameToLastName.priority = firstNameToLastNamePriority
        
        lastNameToPhoneNumber.priority = lastNameToPhoneNumberPriority
        
        self.firstName?.font = firstNameFont
    }
    
    private func configureEmailAndPhoneNumber(showDetailInfo: Bool){
        let emailWidthPriority: UILayoutPriority
        
        let phoneNumberWigthPriority: UILayoutPriority
        
        let emailResistancePriority: UILayoutPriority
        
        if showDetailInfo {
            if phoneNumberText.characters.count <= emailText.characters.count {
                phoneNumberWidth.constant = self.phoneNumberText.width(
                    withConstrainedHeight: 1,
                    font: phoneNumber.font,
                    maxCountOfVisible: Constants.SomeDefaults.countOfDisplayedEmailOrPhoneNumberCharacters
                )
                
                phoneNumberWigthPriority = Priorities.high.rawValue
                
                emailWidthPriority = Priorities.high.rawValue - 10
            } else {
                emailWidth.constant = self.emailText.width(
                    withConstrainedHeight: 1,
                    font: email.font,
                    maxCountOfVisible: Constants.SomeDefaults.countOfDisplayedEmailOrPhoneNumberCharacters
                )
                
                phoneNumberWigthPriority = Priorities.high.rawValue - 10
                
                emailWidthPriority = Priorities.high.rawValue
            }
            
            emailResistancePriority = Priorities.middle.rawValue + 2
        } else {
            emailWidthPriority = Priorities.low.rawValue
            
            phoneNumberWigthPriority = Priorities.high.rawValue
            
            emailResistancePriority = Priorities.middle.rawValue
        }
        
        emailWidth.priority = emailWidthPriority
        
        phoneNumberWidth.priority = phoneNumberWigthPriority
        
        email.setContentCompressionResistancePriority(emailResistancePriority, for: .horizontal)
    }
}

// ContactTVCellProtocol implementation
extension ContactsTVCell {
    func fillCell(fullName: String, firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, constraintsConstant: Int) {
        detailInfoButton.isOn = presenter.showDetailInfo
        
        self.fullNameText = fullName
        
        self.firstNameText = firstName
        
        self.phoneNumberText = phoneNumber
        
        self.emailText = email
        
        leadingConstraint.constant = CGFloat(constraintsConstant)
        
        self.firstName?.text = firstName
        
        self.lastName?.text = lastName
        
        self.phoneNumber?.text = phoneNumber
        
        self.email?.text = email
        
        if photo != nil {
            self.photoImage.image = UIImage(data: (photo)! as Data)
        } else {
            self.photoImage.image = #imageLiteral(resourceName: "noPhoto")
        }
        
        showDetailInfo()
    }
    
    func reloadDataFromPresenter() {
        self.detailInfoButton.isOn = self.presenter.showDetailInfo
        
        self.showDetailInfo(updateTableView: true)
    }
}
