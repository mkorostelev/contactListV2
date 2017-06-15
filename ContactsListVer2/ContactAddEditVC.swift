//
//  ContactAddEditVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/18/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

class ContactAddEditVC: UIViewController, UITextFieldDelegate, ContactAddEditProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var presenter: ContactAddEditPresenterProtocol!
        
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet weak var deleteContactOutlet: UIButton!
    
    @IBOutlet weak var saveContactOutlet: UIBarButtonItem!
    
    @IBOutlet weak var clearLocationButton: UIButton!
    
    @IBOutlet weak var viewLocationButton: UIButton!
    
    var firstName: String {
        get {
            return firstNameOutlet?.text ?? ""
        }
        
        set {
            firstNameOutlet?.text = newValue
        }
    }
    
    var lastName: String {
        get {
            return lastNameOutlet?.text ?? ""
        }
        
        set {
            lastNameOutlet?.text = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return phoneNumberOutlet?.text ?? ""
        }
        
        set {
            phoneNumberOutlet?.text = newValue
        }
    }
    
    var email: String {
        get {
            return emailOutlet?.text ?? ""
        }
        
        set {
            emailOutlet?.text = newValue
        }
    }
    
    var latitude: Double?
    
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()

        presenter.viewDidLoad()
        
        presenter.checkEnabledOfSaveButton(allInputedText: self.allInputedText, notInOutletString: "", range: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setDelegates() {
        firstNameOutlet.delegate = self
        
        lastNameOutlet.delegate = self
        
        phoneNumberOutlet.delegate = self
        
        emailOutlet.delegate = self
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        let photo = getPhotoNSData()
        
        presenter.validateAndSaveContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, photo: photo, latitude: self.latitude, longitude: self.longitude)
    }
    
    @IBAction func deleteContact(_ sender: UIButton) {
        presenter.deleteContact()
    }
    
    @IBOutlet weak var photoButton: UIButton!
    
    @IBAction func clickOnPhoto(_ sender: UIButton) {
        selectPhoto()
    }
    
    func getPhotoNSData() -> NSData? {
        return photoButton.image(for: .normal) != #imageLiteral(resourceName: "noPhoto") ? UIImagePNGRepresentation(photoButton.image(for: .normal)!) as NSData? : nil
    }
    
    func selectPhoto() {
        let camera = DSCameraHandler(delegate_: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        if photoButton.image(for: .normal) != #imageLiteral(resourceName: "noPhoto") {
            let erasePhoto = UIAlertAction(title: "Erase", style: .default) { (alert : UIAlertAction!) in
                self.setPhoto(image: #imageLiteral(resourceName: "noPhoto"))
            }
            
            optionMenu.addAction(erasePhoto)
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.setPhoto(image: image)
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setPhoto(image: UIImage?) {
        photoButton.setImage(image, for: .normal)
    }
    
    @IBAction func eraseLocation(_ sender: UIButton) {
        self.setLocation(latitude: nil, longitude: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.presenter.router.prepare(
            for: segue,
            sender: sender
        )
    }
}

extension ContactAddEditVC {
    var allInputedText: String {
        return "\(self.firstName)\(self.lastName)\(self.phoneNumber)\(self.email)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.phoneNumberOutlet {
            result = DataValidators.validatePhoneNumberInput(value: string)
        }
        
        if result {
            presenter.checkEnabledOfSaveButton(allInputedText: self.allInputedText, notInOutletString: string, range: range)
        }
        
        return result
    }
}

extension ContactAddEditVC {
    var deleteContactButtonIsHidden: Bool {
        get {
            return deleteContactOutlet.isHidden
        }
        
        set {
            deleteContactOutlet.isHidden = newValue
        }
    }
    
    var saveButtonIsEnabled: Bool {
        get {
            return saveContactOutlet.isEnabled
        }
        
        set {
            saveContactOutlet.isEnabled = newValue
        }
    }
    
    func fillTextFieldsData(firstName: String, lastName: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?,
        longitude: Double?) {
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.phoneNumber = phoneNumber
        
        self.email = email
        
        if photo != nil {
            let image = UIImage(data: (photo)! as Data)
            
            self.setPhoto(image: image)
        }
        
        self.latitude = latitude
        
        self.longitude = longitude
        
        fillContactsLocation()
    }
    
    func fillContactsLocation() {
        var text: String = "no location"
        
        var clearButtonIsHidden = true
        
        if let latitudeValue = self.latitude, let longitudeValue = self.longitude {
            text = "\(latitudeValue) \(longitudeValue)"
            
            clearButtonIsHidden = false
        }
        viewLocationButton.setTitle(text, for: .normal)
        
        clearLocationButton.isHidden = clearButtonIsHidden
    }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getDeleteContactAlert(contactFullName: contactFullName, deleteAction: deleteAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentEmailValidationAlert(saveAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getEmailValidationAlert(email: self.email, saveAction: saveAction)
        
        self.present(alertController, animated: true)
    }
    
    func closeView() {
        self.performSegueToRootViewController()
    }
    
    func setLocation(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        
        self.longitude = longitude
        
        fillContactsLocation()
    }
    
    func getLocationInfo() -> (fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        return (fullName: "\(self.firstName) \(self.lastName)", phoneNumber: self.phoneNumber, latitude: self.latitude, longitude: self.longitude)
    }
}
