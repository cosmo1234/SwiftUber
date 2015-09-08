//
//  SwiftUberHelpers.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

extension Float {
    func swiftUberLocationToString() -> String {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        return nf.stringFromNumber(self)!
    }
}

extension String {
    func swiftUberURLformat() -> String {
        var url = self.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        url = url.stringByReplacingOccurrencesOfString(",", withString: "%2C", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        url = url.stringByReplacingOccurrencesOfString("[", withString: "%5B", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        url = url.stringByReplacingOccurrencesOfString("]", withString: "%5D", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return url
    }
}