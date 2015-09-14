//
//  UberProduct.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

class UberProduct: NSObject {
    var id: String!
    var displayName:String?
    var productDescription: String?
    var capacity: Int?
    var priceDetails: PriceDetail?
    var imageURL: String?
    
    // Uber
    var uberPrice: UberPrice?
    var uberTime: UberTime?
    
    init(productId: String) {
        super.init()
        self.id = productId
    }
    
    class func createFromJson(json: [String: AnyObject], swiftUber: SwiftUber) {
        if let id = json["product_id"] as? String {
            let filteredProducts = swiftUber.products.filter( { $0.id == id })
            var uberProduct: UberProduct?
            
            if filteredProducts.count == 0 {
                uberProduct = UberProduct(productId: id)
                swiftUber.products.append(uberProduct!)
            } else {
                uberProduct = filteredProducts.first
            }
            
            if let product = uberProduct as UberProduct? {
                product.updateFromJson(json)
                
            }
            
        }
    }
    
    // From Get Products or Get Product
    func updateFromJson(json: [String: AnyObject]) {
        
        // Get From Get Products or Get Product
        if let capacity = json["capacity"] as? Int {
            self.capacity = capacity
        } else if let capacity = json["capacity"] as? NSNumber {
            self.capacity = Int(capacity)
        } else if let capacity = json["capacity"] as? Float {
            self.capacity = Int(capacity)
        } else if let capacity = json["capacity"] as? String {
            self.capacity = Int(capacity)
        }
        
        if let description = json["description"] as? String {
            self.productDescription = description
        }
        
        if let price_details = json["price_details"] as? [String: AnyObject] {
            self.priceDetails = PriceDetail(json: price_details)
        }
        
        if let image = json["image"] as? String {
            self.imageURL = image
        }
        
        if let displayName = json["display_name"] as? String {
            self.displayName = displayName
        }
        
    }
    
    
    
}

class PriceDetail: NSObject {
    var distanceUnit: String?
    var costPerMinute: Float?
    var serviceFees: [ServiceFee] = []
    var minimum: Float?
    var costPerDistance: Float?
    var base: Float?
    var cancellationFee: Float?
    var currencyCode: String?
    
    init(json: [String: AnyObject]) {
        super.init()
        
        if let distance_unit = json["distance_unit"] as? String {
            self.distanceUnit = distance_unit
        }
        
        if let cost_per_minute = json["cost_per_minute"] as? Float {
            self.costPerMinute = cost_per_minute
        } else if let cost_per_minute = json["cost_per_minute"] as? NSNumber {
            self.costPerMinute = Float(cost_per_minute)
        } else if let cost_per_minute = json["cost_per_minute"] as? String {
            self.costPerMinute = (cost_per_minute as NSString).floatValue
        }
        
        if let service_fees = json["service_fees"] as? [AnyObject] {
            var serviceFeeArray: [ServiceFee] = []
            for object in service_fees {
                if let serviceFeeObject = object as? [String: AnyObject] {
                    let serviceFee = ServiceFee(json: serviceFeeObject)
                    serviceFeeArray.append(serviceFee)
                }
            }
            self.serviceFees = serviceFeeArray
        }
        
        if let minimum = json["mimimum"] as? Float {
            self.minimum = minimum
        } else if let minimum = json["mimimum"] as? Float {
            self.minimum = Float(minimum)
        } else if let minimum = json["mimimum"] as? String {
            self.minimum = (minimum as NSString).floatValue
        }
        
        if let cost_per_distance = json["cost_per_distance"] as? Float {
            self.costPerDistance = cost_per_distance
        } else if let cost_per_distance = json["cost_per_distance"] as? NSNumber {
            self.costPerDistance = Float(cost_per_distance)
        } else if let cost_per_distance = json["cost_per_distance"] as? String {
            self.costPerDistance = (cost_per_distance as NSString).floatValue
        }
        
        if let base = json["base"] as? Float {
            self.base = base
        } else if let base = json["base"] as? NSNumber {
            self.base = Float(base)
        } else if let base = json["base"] as? String {
            self.base = (base as NSString).floatValue
        }
        
        if let cancellation_fee = json["cancellation_fee"] as? Float {
            self.cancellationFee = cancellation_fee
        } else if let cancellation_fee = json["cancellation_fee"] as? NSNumber {
            self.cancellationFee = Float(cancellation_fee)
        } else if let cancellation_fee = json["cancellation_fee"] as? String {
            self.cancellationFee = (cancellation_fee as NSString).floatValue
        }
        
        if let currency_code = json["currency_code"] as? String {
            self.currencyCode = currency_code
        }
    }
    
}

class ServiceFee: NSObject {
    var fee: Float?
    var name: String?
    
    init(json: [String: AnyObject]) {
        super.init()
        if let fee = json["fee"] as? Float {
            self.fee = fee
        } else if let fee = json["fee"] as? NSNumber {
            self.fee = Float(fee)
        } else if let fee = json["fee"] as? String {
            self.fee = (fee as NSString).floatValue
        }
    }
}