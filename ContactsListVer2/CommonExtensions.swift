//
//  Extensions.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UITableViewCell {
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont, maxCountOfVisible: Int) -> CGFloat {
        var visiblePart = self + " "
        
        if maxCountOfVisible < self.characters.count {
            let index = self.index(self.startIndex, offsetBy: maxCountOfVisible)
            
            visiblePart = self.substring(to: index) + "   "
        }
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = visiblePart.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}
