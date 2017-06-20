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
    
    @IBOutlet weak var viewLocationButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var activeField: UITextField?
    
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
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //
    }

    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(_ notification: Notification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(
                top: self.navigationController?.navigationBar.bounds.height ?? 0 + UIApplication.shared.statusBarFrame.height,
                left: 0.0,
                bottom: keyboardSize.height,
                right: 0.0
            )
            
            self.scrollView.contentInset = contentInsets
            
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect = self.view.frame
            
            aRect.size.height -= keyboardSize.size.height
            
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    //
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.presenter.router.prepare(
            for: segue,
            sender: sender
        )
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        return self.presenter.router.shouldPerformSegue(withIdentifier: identifier)
    }
}

// work with photo
extension ContactAddEditVC {
    func getPhotoNSData() -> NSData? {
        return photoButton.image(for: .normal) != #imageLiteral(resourceName: "noPhoto") ? UIImagePNGRepresentation(photoButton.image(for: .normal)!) as NSData? : nil
    }
    
    func selectPhoto() {
        let camera = DSCameraHandler(delegate_: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        if camera.isCameraAvailable {
            let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
                camera.getCameraOn(self, canEdit: true)
            }
            
            optionMenu.addAction(takePhoto)
        }
        
        if camera.isPhotoLibraryAvailable {
            let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
                camera.getPhotoLibraryOn(self, canEdit: true)
            }
            
            optionMenu.addAction(sharePhoto)
        }
        
        if camera.isSavedPhotoAlbumAvailable {
            let savedPhotosAlbum = UIAlertAction(title: "Saved Photos Album", style: .default) { (alert : UIAlertAction!) in
                camera.getSavedPhotosAlbumOn(self, canEdit: true)
            }
            
            optionMenu.addAction(savedPhotosAlbum)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        
        if photoButton.image(for: .normal) != #imageLiteral(resourceName: "noPhoto") {
            let erasePhoto = UIAlertAction(title: "Erase", style: .destructive) { (alert : UIAlertAction!) in
                self.setPhoto(image: #imageLiteral(resourceName: "noPhoto"))
            }
            
            optionMenu.addAction(erasePhoto)
        }
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.setPhoto(image: image)
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setPhoto(image: UIImage?) {
        photoButton.setImage(image, for: .normal)
        
        photoButton.imageView?.contentMode = .scaleAspectFit
    }
}

// textField delegates
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

// ContactAddEditProtocol implementation
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
        
        if let latitudeValue = self.latitude, let longitudeValue = self.longitude {
            text = "\(latitudeValue) \(longitudeValue)"
        }
        
        viewLocationButton.setTitle(text, for: .normal)
    }
    
    func presentDeletionAlert(contactFullName: String, deleteAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getDeleteContactAlert(contactFullName: contactFullName, deleteAction: deleteAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentEmailValidationAlert(saveAction: @escaping (() -> Void)) {
        let alertController = AlertsCreator.getEmailValidationAlert(email: self.email, saveAction: saveAction)
        
        self.present(alertController, animated: true)
    }
    
    func closeViewAndGoToRoot() {
        self.performSegueToRootViewController()
    }
    
    func closeViewAndGoBack() {
        self.performSegueToReturnBack()
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
