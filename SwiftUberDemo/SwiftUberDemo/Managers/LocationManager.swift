//
//  LocationManager.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

public class LocationManager: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: LocationManager {
        struct Static {
            static var instance: LocationManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LocationManager()
        }
        return Static.instance!
    }
    
    var enabled: Bool {
        get {
            switch (CLLocationManager.authorizationStatus()) {
            case .Denied, .Restricted:
                return false
            default:
                return true
            }
        }
    }
    
    var currentLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
        }()
    
    func start(){
        if enabled {
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //func locationManager
}

