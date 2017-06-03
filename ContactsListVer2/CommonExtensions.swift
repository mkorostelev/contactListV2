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
