//
//  UberNetworking.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class UberNetworking: NSObject {
    
    enum EndPoints: String {
        case ProductTypes = "/v1/products"
        case PriceEstimates = "/v1/estimates/price"
        case TimeEstimates = "/v1/estimates/time"
        case Promotions = "/v1/promotions"
        case UserActivity = "/v1.2/history"
        case UserProfile = "/v1/me"
        case Request = "/v1/requests"
    }
    
    var swiftUber: SwiftUber!
    let serverToken: String!
    let baseUrl:String = "https://api.uber.com"
    
    
    init(serverToken: String, swiftUber: SwiftUber) {
        self.serverToken = serverToken
        self.swiftUber = swiftUber
    }
    
    func getAllProducts(location: CLLocation, completion: ((Bool, NSError?) -> Void)?) {
        let startLat = Float(location.coordinate.latitude)
        let startLon = Float(location.coordinate.longitude)
        
        var urlString = self.baseUrl + EndPoints.ProductTypes.rawValue
        urlString += "?server_token=" + self.serverToken
        urlString += "&latitude=" + startLat.swiftUberLocationToString()
        urlString += "&longitude=" + startLon.swiftUberLocationToString()
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            println("response \(response)")
            var success = false
            if let responseData = data as NSData? {
                if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? [String: AnyObject] {
                    
                    if let products = json["products"] as? [[String: AnyObject]] {
                        success = true
                        for product in products {
                            UberProduct.createFromJson(product, swiftUber: self.swiftUber)
                        }
                    }
                }
            }
            
            completion?(success, error)
            
        })
        
    }
    
    func getPriceEstimates(ride: UberRide, completion: (([UberPrice]?, NSError?) -> Void)?) {
        if let origin = ride.pickupLocation as CLLocation? {
            if let destination  = ride.dropOffLocation as CLLocation? {
                let startLat = Float(origin.coordinate.latitude)
                let startLon = Float(origin.coordinate.longitude)
                let endLat = Float(destination.coordinate.latitude)
                let endLon = Float(destination.coordinate.longitude)
                
                var urlString = self.baseUrl + EndPoints.PriceEstimates.rawValue
                urlString += "?server_token=" + self.serverToken
                urlString += "&start_latitude=" + startLat.swiftUberLocationToString()
                urlString += "&start_longitude=" + startLon.swiftUberLocationToString()
                urlString += "&end_latitude=" + endLat.swiftUberLocationToString()
                urlString += "&end_longitude=" + endLon.swiftUberLocationToString()
                
                let url = NSURL(string: urlString)
                let request = NSURLRequest(URL: url!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    println("response \(response)")
                    
                    var uberPrices:[UberPrice] = []
                    
                    if let responseData = data as NSData? {
                        if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? [String: AnyObject] {
                            
                            if let prices = json["prices"] as? [[String: AnyObject]] {
                                
                                for price in prices {
                                    if let id = price["product_id"] as? String {
                                        let uberPrice = UberPrice(json: price, swiftUber: self.swiftUber)
                                        uberPrice.attachToUberProduct()
                                        uberPrice.ride = ride
                                        uberPrices.append(uberPrice)
                                    }
                                }
                            }
                        }
                    }
                    
                    completion?(uberPrices, error)
                    
                })
            }
        } else {
            // no destination
            completion?([], nil)
        }
    }
    
    
    func launchUber(ride: UberRide, clientId: String) {
        if let url = self.createUberAppUrl(ride, clientId: clientId) as NSURL? {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
                return
            }
        }
        
        if let webUrl = self.createUberWebUrl(ride, clientId:clientId) as NSURL? {
            UIApplication.sharedApplication().openURL(webUrl)
        }
        
    }
    
    func createUberAppUrl(ride: UberRide, clientId: String) -> NSURL? {
        var urlString = "uber://?client_id=" + clientId + "&action=setPickup&pickup=my_location"
        
        if let productId = ride.product?.id as String? {
            urlString += "&product_id=" + productId
        }
        
        if let dropOffLat = ride.dropOffLatitude as Float? {
            if let dropOffLong = ride.dropOffLongitude as Float? {
                urlString += "&dropoff[latitude]=" + dropOffLat.swiftUberLocationToString() + "&dropoff[longitude]=" + dropOffLong.swiftUberLocationToString()
            }
        }
        
        if let nickname = ride.dropOffNickName as String? {
            urlString += "&dropoff[nickname]=" + nickname
        }
        
        if let formattedAddress = ride.dropOffAddress as String? {
            urlString += "&dropoff[formatted_address]=" + formattedAddress
        }
        
        return NSURL(string: urlString.swiftUberURLformat())
    }
    
    func createUberWebUrl(ride: UberRide, clientId: String) -> NSURL? {
        var urlString = "https://m.uber.com/sign-up?client_id=" + clientId
        
        if let pickUpLat = ride.pickupLatitude as Float? {
            if let pickUpLon = ride.pickupLongitude as Float? {
                urlString += "&pickup_latitude=" + pickUpLat.swiftUberLocationToString() + "&pickup_longitude=" + pickUpLon.swiftUberLocationToString()
            }
        }
        
        if let pickUpNickName = ride.pickupNickName as String? {
            urlString += "&pickup_nickname=" + pickUpNickName
        }
        
        if let pickUpAddress = ride.pickupAddress as String? {
            urlString += "&pickup_address=" + pickUpAddress
        }
        
        if let dropOffLat = ride.dropOffLatitude as Float? {
            if let dropOffLong = ride.dropOffLongitude as Float? {
                urlString += "&dropoff_latitude=" + dropOffLat.swiftUberLocationToString() + "&dropoff_longitude_=" + dropOffLong.swiftUberLocationToString()
            }
        }
        
        if let nickname = ride.dropOffNickName as String? {
            urlString += "&dropoff_nickname=" + nickname
        }
        
        if let formattedAddress = ride.dropOffAddress as String? {
            urlString += "&dropoff_formatted_address=" + formattedAddress
        }
        
        return NSURL(string: urlString.swiftUberURLformat())
    }
}
