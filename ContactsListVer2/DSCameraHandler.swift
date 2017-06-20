//
//  DSCameraHandler.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/14/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import Foundation

import MobileCoreServices
import UIKit

class DSCameraHandler: NSObject {
    
    private let imagePicker = UIImagePickerController()
    let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
    let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    private let isRearCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear)
    private let isFrontCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)
    private let sourceTypeCamera = UIImagePickerControllerSourceType.camera
    private let rearCamera = UIImagePickerControllerCameraDevice.rear
    private let frontCamera = UIImagePickerControllerCameraDevice.front
    
    var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func getPhotoLibraryOn(_ onVC: UIViewController, canEdit: Bool) {
        if !isPhotoLibraryAvailable { return }
        
        let type = kUTTypeImage as String
        
        if isPhotoLibraryAvailable {
            imagePicker.sourceType = .photoLibrary
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = delegate
        onVC.present(imagePicker, animated: true, completion: nil)
    }
    
    func getSavedPhotosAlbumOn(_ onVC: UIViewController, canEdit: Bool) {
        if !isSavedPhotoAlbumAvailable { return }
        
        let type = kUTTypeImage as String
        
        if isSavedPhotoAlbumAvailable {
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = delegate
        onVC.present(imagePicker, animated: true, completion: nil)
    }
    
    func getCameraOn(_ onVC: UIViewController, canEdit: Bool) {
        
        if !isCameraAvailable { return }
        let type1 = kUTTypeImage as String
        
        if isCameraAvailable {
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if availableTypes.contains(type1) {
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = sourceTypeCamera
                }
            }
            
            if isRearCameraAvailable {
                imagePicker.cameraDevice = rearCamera
            } else if isFrontCameraAvailable {
                imagePicker.cameraDevice = frontCamera
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        onVC.present(imagePicker, animated: true, completion: nil)
    }
}


