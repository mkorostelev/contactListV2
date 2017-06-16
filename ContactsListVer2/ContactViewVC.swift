//
//  ContactViewVC.swift
//  ContactsListVer2
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

import MapKit

class ContactViewVC: UIViewController, ContactViewProtocol {
    var presenter: ContactViewPresenterProtocol!
    
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    @IBOutlet weak var phoneNumberCenter: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberOutletCenter: NSLayoutConstraint!
    
    @IBOutlet weak var emailCenter: NSLayoutConstraint!
    
    @IBOutlet weak var emailOutletCenter: NSLayoutConstraint!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberCenter.constant -= view.bounds.width
        
        phoneNumberOutletCenter.constant -= view.bounds.width
        
        emailCenter.constant -= view.bounds.width
        
        emailOutletCenter.constant -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.phoneNumberCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.phoneNumberOutletCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.emailCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.emailOutletCenter.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// ContactViewProtocol implementation
extension ContactViewVC {
    func fillDataFromContact(title: String, phoneNumber: String, email: String, photo: NSData?, latitude: Double?, longitude: Double?) {
        self.navigationItem.title = title
        
        phoneNumberOutlet?.text = phoneNumber
        
        emailOutlet?.text = email
        
        if photo != nil {
            self.photoImage.image = UIImage(data: (photo)! as Data)
        }
        
        if let latitudeValue = latitude, let longitudeValue = longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.title = title
            
            annotation.subtitle = phoneNumber
            
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
        } else {
            mapView.isHidden = true
        }
    }
}
