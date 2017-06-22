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
    
    var address: String?
    
    var fullName: String = ""
    
    var phoneNumber: String = ""
    
    var locationManager: CLLocationManager!
    
    var destinationMapItem: MKMapItem?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.onViewDidLoad()
        
        mapView.delegate = self
        
        mapView.mapType = MKMapType.standard
        
        mapView.showsUserLocation = true
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longPress))
        
        gestureRecognizer.minimumPressDuration = 1.0
        
        gestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.removeOverlays(mapView.overlays)
        
        let location = gestureRecognizer.location(in: mapView)
        
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        setDestinationPoint(coordinate: coordinate)
        
        determineCurrentLocation()
    }
    
    private func setDestinationPoint(coordinate: CLLocationCoordinate2D) {
        annotation.title = fullName
        
        annotation.subtitle = phoneNumber
        
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
        let destinationPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveLocation(_ sender: UIBarButtonItem) {
        saveLocationAction()
    }
    
    private func saveLocationAction() {
        self.presenter.setLocation(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude, address: self.address)
        
        self.performSegueToReturnBack()
    }
    
    func fillDataFromContact(fullName: String, phoneNumber: String, latitude: Double?, longitude: Double?) {
        self.navigationItem.title = fullName
        
        self.fullName = fullName
        
        self.phoneNumber = phoneNumber
        
        if let latitudeValue = latitude, let longitudeValue = longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            setDestinationPoint(coordinate: coordinate)
        }
        
        determineCurrentLocation()
    }
    
    private func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        sleep(1)
        
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
                
                for step in route.steps {
                    print(step.instructions)
                }

                let rect = route.polyline.boundingMapRect
                
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
             
                self.saveButtonOutlet.isEnabled = true

                let destinationLocation = CLLocation(latitude: destinationMapItemValue.placemark.coordinate.latitude, longitude: destinationMapItemValue.placemark.coordinate.longitude)

                self.getPlacemark(forLocation: destinationLocation) {
                    (originPlacemark, error) in
                    if let err = error {
                        self.address = nil
                        
                        debugPrint(err)
                    } else if let placemark = originPlacemark {
                        if let address = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                            self.address = address.joined(separator: ", ")
                        }
                    }
                }
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
    
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
    }
    
}
