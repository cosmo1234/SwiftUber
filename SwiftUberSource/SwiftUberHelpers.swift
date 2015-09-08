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