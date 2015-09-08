//
//  SwiftUber.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class SwiftUber: NSObject {
    
    var products: [UberProduct] = []
    
    private let serverToken: String!
    
    init(serverToken: String){
        self.serverToken = serverToken
    }
    
    func allProducts(location: CLLocation, completion: (([UberProduct], NSError?) -> Void)?) {
        let uberNetworking = UberNetworking(serverToken: self.serverToken, swiftUber: self)
        uberNetworking.getAllProducts(location, completion: {
            (success: Bool, error: NSError?) -> Void in
            completion?(self.products, error)
        })
    }
    
    func getProduct() {
        //
    }
    
    func priceEstimate(ride: UberRide, completion: (([UberPrice]?, NSError?) -> Void)?){
        let uberNetworking = UberNetworking(serverToken: self.serverToken, swiftUber: self)
        uberNetworking.getPriceEstimates(ride, completion: {
            (uberPrices: [UberPrice]?, error: NSError?) -> Void in
            completion?(uberPrices, error)
        })
    }
    
    func timeEstimate() {
        //
    }
    
    func promotions() {
        //
    }
    
    func openUber(ride: UberRide, clientId:String){
        let uberNetworking = UberNetworking(serverToken: self.serverToken, swiftUber: self)
        uberNetworking.launchUber(ride, clientId: clientId)
    }
}
