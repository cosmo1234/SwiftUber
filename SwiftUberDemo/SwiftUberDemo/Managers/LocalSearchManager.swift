//
//  LocalSearchManager.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class LocalSearchManager {
    class func search(searchText: String, region: MKCoordinateRegion?, completion:(([MKMapItem], NSError?)-> Void)?) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchText
        if let mapRegion = region as MKCoordinateRegion? {
            searchRequest.region = mapRegion
        }
        
        let search = MKLocalSearch(request: searchRequest)
        search.startWithCompletionHandler({
            (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            var mapItems:[MKMapItem] = []
            if error != nil {
                print("Local Search Error: \(error)")
                return
            }
            
            if let result = response?.mapItems as? [MKMapItem] {
                mapItems = result
            }
            
            completion?(mapItems, error)
        })

    }
}
