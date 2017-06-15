//
//  ContactsLocationVC.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 6/14/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

import CoreLocation

import MapKit

class ContactsLocationVC: UIViewController, MKMapViewDelegate, ContactsLocationProtocol, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    var presenter: ContactsLocationPresenterProtocol!
    
    var annotation = MKPointAnnotation()
    
    var fullName: String = ""
    
    var phoneNumber: String = ""
    
    var locationManager: CLLocationManager!
    
    var destinationMapItem: MKMapItem?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.mapType = MKMapType.standard
        
        mapView.showsUserLocation = true
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longPress))
        gestureRecognizer.minimumPressDuration = 2.0
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.removeOverlays(mapView.overlays)
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        annotation.title = fullName
        annotation.subtitle = phoneNumber
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let destinationPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        determineCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveLocation(_ sender: UIBarButtonItem) {
        self.presenter.setLocation(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude)
        
        self.performSegueToReturnBack()
    }
    
    func fillDataFromContact(fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        self.navigationController?.title = fullName
        
        self.fullName = fullName
        
        self.phoneNumber = phoneNumber
        
        if let latitudeValue = latitude, let longitudeValue = longitude {
            let location = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            
            annotation.title = fullName
            annotation.subtitle = phoneNumber
            annotation.coordinate = location
            
            mapView.addAnnotation(annotation)
            
            let destinationPlacemark = MKPlacemark(coordinate: location, addressDictionary: nil)
            
            destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        } //else {
            determineCurrentLocation()
        //}
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        let location = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        myAnnotation.coordinate = location
        myAnnotation.title = "Current location"
        
        mapView.addAnnotation(myAnnotation)
        
        if let destinationMapItemValue = destinationMapItem {
            let sourcePlacemark = MKPlacemark(coordinate: location, addressDictionary: nil)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItemValue
            directionRequest.transportType = .automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}
