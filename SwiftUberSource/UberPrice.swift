//
//  UberPrice.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

class UberPrice: NSObject {
    let swiftUber: SwiftUber!
    var uberProduct: UberProduct?
    var currencyCode: String?
    var productId: String?
    var displayName: String?
    var estimate: String?
    var lowEstimate: Int?
    var highEstimate: Int?
    var surgeMultiplier: Float?
    var duration: Int?
    var distance: Float?
    
    var ride: UberRide?
    
    init(json: [String: AnyObject], swiftUber: SwiftUber) {
        self.swiftUber = swiftUber
        if let product_id = json["product_id"] as? String {
            self.productId = product_id
        }
        
        if let currency_code = json["currency_code"] as? String? {
            self.currencyCode = currency_code
        }
        
        if let display_name = json["display_name"] as? String {
            self.displayName = display_name
        }
        
        if let estimate = json["estimate"] as? String {
            self.estimate = estimate
        }
        
        if let low_estimate = json["low_estimate"] as? Int {
            self.lowEstimate = low_estimate
        }
        
        if let high_estimate = json["high_estimate"] as? Int {
            self.highEstimate = high_estimate
        }
        
        if let surge_multiplier = json["surge_multiplier"] as? Float {
            self.surgeMultiplier = surge_multiplier
        }
        
        if let duration = json["duration"] as? Int {
            self.duration = duration
        }
        
        if let distance = json["distance"] as? Float {
            self.distance = distance
        }
    }
    
    func attachToUberProduct() {
        if let productId = self.productId as String? {
            let filteredProducts = self.swiftUber.products.filter( { $0.id == productId })
            if filteredProducts.count == 1 {
                let product = filteredProducts[0]
                self.uberProduct = product
                product.uberPrice = self
            } else {
                // create product
                let product = UberProduct(productId: productId)
                product.displayName = self.displayName
                product.uberPrice = self
                self.swiftUber.products.append(product)
            }
        }
    }
}
