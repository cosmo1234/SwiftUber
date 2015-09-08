//
//  UberTime.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

class UberTime: NSObject {
    var swiftUber: SwiftUber!
    var productId:String?
    var product: UberProduct?
    var displayName: String?
    var estimate: Int?
    
    init(json: [String: AnyObject], swiftUber: SwiftUber) {
        
        self.swiftUber = swiftUber
        
        if let product_id = json["product_id"] as? String {
            self.productId = product_id
        }
        
        if let display_name = json["display_name"] as? String {
            self.displayName = display_name
        }
        
        if let estimate = json["estimate"] as? Int {
            self.estimate = estimate
        }
    }
    
    func attachToUberProduct() {
        if let productId = self.productId as String? {
            let filteredProducts = self.swiftUber.products.filter( { $0.id == productId })
            if filteredProducts.count == 1 {
                let product = filteredProducts[0]
                self.product = product
                product.uberTime = self
            } else {
                // create product
                var product = UberProduct(productId: productId)
                product.displayName = self.displayName
                product.uberTime = self
                self.swiftUber.products.append(product)
            }
        }
    }
}
