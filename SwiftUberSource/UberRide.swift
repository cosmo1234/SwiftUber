//
//  UberRide.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class UberRide: NSObject {
    var swiftUber: SwiftUber?
    var productId: String?
    var  _uberProduct: UberProduct?
    var uberProduct: UberProduct? {
        get {
            if let product = _uberProduct as UberProduct? {
                return product
            }
            return nil
        }
        set (value) {
            if let product = value as UberProduct? {
                _uberProduct = product
                productId = product.id
            } else {
                _uberProduct = nil
            }
        }
    }
    var pickupLatitude: Float?
    var pickupLongitude: Float?
    var pickupLocation: CLLocation?
    var pickupNickName: String?
    var pickupAddress: String?
    var dropOffLatitude: Float?
    var dropOffLongitude: Float?
    var dropOffNickName: String?
    var dropOffAddress: String?
    var _dropOffLocation: CLLocation?
    var dropOffLocation: CLLocation? {
        get {
            if let location = _dropOffLocation as CLLocation? {
                return location
            }
            return nil
        }
        set (value){
            if let location = value as CLLocation? {
                dropOffLatitude = Float(location.coordinate.latitude)
                dropOffLongitude = Float(location.coordinate.longitude)
                _dropOffLocation = location
            } else {
                _dropOffLocation = nil
            }
        }
    }
    
    init(pickupLocation: CLLocation) {
        self.pickupLocation = pickupLocation
        pickupLatitude = Float(pickupLocation.coordinate.latitude)
        pickupLongitude = Float(pickupLocation.coordinate.longitude)
    }
    
    func setDestinationAddress(address: String, completion:((Bool)-> Void)?) {
        self.dropOffAddress = address
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {
            (placemarks: [AnyObject]?, error: NSError?) -> Void in
            var success = false
            var location:CLLocation?
            
            if let pmarks = placemarks as? [CLPlacemark] {
                if let placemark = pmarks[0] as CLPlacemark? {
                    location = placemark.location
                    self.dropOffLocation = location
                    success = true
                }
            }
            completion?(success)
        })
    }
}
