//
//  UberPromotion.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

class UberPromotion: NSObject {
    var displayText: String?
    var localizedValue: String?
    var type: String?
    
    init(json: [String: AnyObject]) {
        if let displayText = json["display_text"] as? String {
            self.displayText = displayText
        }
        
        if let localized_value = json["localized_value"] as? String {
            self.localizedValue = localized_value
        }
        
        if let type = json["type"] as? String {
            self.type = type
        }
    }
}
