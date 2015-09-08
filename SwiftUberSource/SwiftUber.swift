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
    
    internal var products: [UberProduct] = []
    
    let serverToken: String!
    
    init(serverToken: String){
        self.serverToken = serverToken
    }
    
    class func allProducts() {
        //
    }
    
    class func getProduct() {
        //
    }
    
    class func priceEstimate(){
        //
    }
    
    class func timeEstimate() {
        //
    }
    
    class func promotions() {
        //
    }
    
    class func openUber(clientId:String){
        //
    }
}
