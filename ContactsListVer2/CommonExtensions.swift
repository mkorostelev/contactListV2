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

extension UITableView {
    var indexPathForEditingRow: IndexPath? {
        return indexPathsForEditingRows.first
    }
    
    var indexPathsForEditingRows: [IndexPath] {
        return visibleCells.flatMap { cell -> IndexPath? in
            guard let indexPath = indexPath(for: cell), cell.editingStyle != .none else {
                return nil
            }
            return indexPath
        }
    }
    
    var indexPathForDeletingRow: IndexPath? {
        return indexPathsForDeletingRows.first
    }
    
    var indexPathsForDeletingRows: [IndexPath] {
        return visibleCells.flatMap { cell -> IndexPath? in
            guard let indexPath = indexPath(for: cell), cell.editingStyle == .delete else {
                return nil
            }
            return indexPath
        }
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
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

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
