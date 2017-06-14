//
//  ContactsLocationVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/14/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

import MapKit

class ContactsLocationVC: UIViewController, MKMapViewDelegate, ContactsLocationProtocol, UIGestureRecognizerDelegate {
    var presenter: ContactsLocationPresenterProtocol!
    
    var annotation = MKPointAnnotation()
    
    var fullName: String = ""
    
    var phoneNumber: String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.mapType = MKMapType.standard
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longPress))
        gestureRecognizer.minimumPressDuration = 2.0
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        annotation.title = fullName
        annotation.subtitle = phoneNumber
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveLocation(_ sender: UIBarButtonItem) {
        self.presenter.setLocation(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude)
        
        self.performSegueToReturnBack()
    }
    
    func fillDataFromContact(fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        self.fullName = fullName
        
        self.phoneNumber = phoneNumber
        
        if let latitudeValue = latitude, let longitudeValue = longitude {
            let location = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            annotation.coordinate = location
            annotation.title = title
            annotation.subtitle = phoneNumber
            mapView.addAnnotation(annotation)
        }
    }
    
}
