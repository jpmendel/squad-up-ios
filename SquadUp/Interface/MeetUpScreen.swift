//
//  MeetUpScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/9/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit
import MapKit

class MeetUpScreen: BaseScreen, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private var map: MKMapView!
    
    private var statusText: UILabel!
    
    private var meetNowButton: UIButton!
    
    private var notifyGroupButton: UIButton!
    
    private var locationManager = CLLocationManager()
    
    private var myLocation: CLLocation? = nil
    
    private var locations = [String: CLLocationCoordinate2D]()
    
    private var locationMarkers = [MKAnnotation]()
    
    private var user: User!
    
    private var group: Group!

    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Up"
        initializeMap()
        initializeLocationManager()
        formatScreen()
        resetValues()
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BackendManager.stopListening(to: group.id)
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        map = view.viewWithTag(1) as! MKMapView
        statusText = view.viewWithTag(2) as! UILabel
        meetNowButton = view.viewWithTag(3) as! UIButton
        notifyGroupButton = view.viewWithTag(4) as! UIButton
        hideUIOffScreen()
        startAnimatingText()
    }
    
    internal override func screenCompatibility() {
        super.screenCompatibility()
        if UIScreen.main.screenSize == .iPhoneX {
            map.iPhoneXNavBarCorrection()
        }
    }
    
    private func formatScreen() {
        meetNowButton.layer.cornerRadius = 10
        meetNowButton.clipsToBounds = true
        notifyGroupButton.layer.cornerRadius = 10
        notifyGroupButton.clipsToBounds = true
    }
    
    private func resetValues() {
        user = User("test@email.com", "Test User")
        group = Group(withName: "Test Group")
        locations = [String: CLLocationCoordinate2D]()
        locationMarkers = [MKAnnotation]()
    }
    
    private func hideUIOffScreen() {
        map.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width, y: 0.0)
        meetNowButton.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width, y: 0.0)
        notifyGroupButton.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width, y: 0.0)
    }
    
    private func initializeMap() {
        map.delegate = self
        map.showsUserLocation = false
        map.showsBuildings = true
        map.showsCompass = false
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.isRotateEnabled = false
        map.isPitchEnabled = false
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization() // Ask for permission.
        locationManager.requestLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        myLocation = location
        addLocation(location.coordinate, for: user.id, named: user.name)
        initializeMeetUpNotificationReceiver()
        setInitialRegion()
        sendLoginMessage()
        animateScreenIn()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[MeetUpScreen] Failed to update location.")
    }
    
    private func setInitialRegion() {
        if let location = myLocation {
            updateZoom(location, width: 0.003, height: 0.003)
        }
    }
    
    private func zoomToFit() {
        var minLat = 0.0
        var maxLat = 0.0
        var minLong = 0.0
        var maxLong = 0.0
        for location in locations.values {
            if minLat == 0.0 {
                minLat = location.latitude
                maxLat = location.latitude
            }
            if minLong == 0.0 {
                minLong = location.longitude
                maxLong = location.longitude
            }
            if location.latitude < minLat {
                minLat = location.latitude
            } else if location.latitude > maxLat {
                maxLat = location.latitude
            }
            if location.longitude < minLong {
                minLong = location.longitude
            } else if location.longitude > maxLong {
                maxLong = location.longitude
            }
        }
        let latSpan = abs(maxLat - minLat) * 1.5
        let longSpan = abs(maxLong - minLong) * 1.5
        let avgLat = (minLat + maxLat) / 2.0
        let avgLong = (minLong + maxLong) / 2.0
        let span = MKCoordinateSpanMake(latSpan, longSpan)
        let center = CLLocationCoordinate2DMake(avgLat, avgLong)
        let region = MKCoordinateRegionMake(center, span)
        map.setRegion(region, animated: true)
    }
    
    private func updateZoom(_ center: CLLocation, width: Double, height: Double) {
        let span = MKCoordinateSpanMake(width, height)
        let location = CLLocationCoordinate2DMake(center.coordinate.latitude, center.coordinate.longitude)
        let region = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
    }
    
    private func addLocation(_ location: CLLocationCoordinate2D, for id: String, named name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        locationMarkers += [annotation]
        map.addAnnotation(annotation)
    }
    
    private func sendLoginMessage() {
        if let location = myLocation {
            BackendManager.sendLoginMessage(to: group.id, user.id, user.name, location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    private func sendLocationMessage() {
        if let location = myLocation {
            BackendManager.sendLocationMessage(to: group.id, user.id, user.name, location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            var pin: MKPinAnnotationView
            if let marker = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView {
                marker.annotation = annotation
                pin = marker
            } else {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            }
            pin.pinTintColor = UIColor.appMediumOrange
            return pin
        }
    }
    
    private func initializeMeetUpNotificationReceiver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(loginNotification(_:)),
            name: .loggedIntoGroup, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(locationNotification(_:)),
            name: .sentLocationBack, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(readyRequestNotification(_:)),
            name: .readyRequest, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(readyResponseNotification(_:)),
            name: .readyResponse, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(readyDecisionNotification(_:)),
            name: .readyDecision, object: nil
        )
        BackendManager.startListening(to: group.id)
    }
    
    @objc private func loginNotification(_ notification: Notification) {
        
    }
    
    @objc private func locationNotification(_ notification: Notification) {
        
    }
    
    @objc private func readyRequestNotification(_ notification: Notification) {
        
    }
    
    @objc private func readyResponseNotification(_ notification: Notification) {
        
    }
    
    @objc private func readyDecisionNotification(_ notification: Notification) {
        
    }
    
    private func startAnimatingText() {
        statusText.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.statusText.alpha = 0.0
        }, completion: {
            finished in
        })
    }
    
    private func stopAnimatingText() {
        statusText.layer.removeAllAnimations()
    }
    
    private func animateScreenIn() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.map.transform = CGAffineTransform.identity
            self.meetNowButton.transform = CGAffineTransform.identity
            self.notifyGroupButton.transform = CGAffineTransform.identity
        }, completion: {
            finished in
        })
    }

}
