//
//  ContactListTVCProtocol.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/31/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

protocol ContactListTVCProtocol: class {
    var viewIsEditing: Bool { get set }
    
    var viewBackButtonIsEnabled: Bool { get set }
    
    var viewBackButtonTitle: String { get set }
    
    var sortMethodSegmentControlIsHidden: Bool { get set }
    
    var sortMethodSegmentControlSelectedSegmentIndex: Int { get set }
    
    func moveRow(at rowAt: Int, to rowTo: Int)
    
    func deleteRow(at row: Int)
    
    func insertRow(at row: Int)
    
    func reloadData()
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void))
}
