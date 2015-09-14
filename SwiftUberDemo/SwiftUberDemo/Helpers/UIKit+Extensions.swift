//
//  UIKit+Extensions.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/13/15.
//  Copyright © 2015 Sean Wilson. All rights reserved.
//

import UIKit

extension Float {
    func toCurrency() -> String {
        let nf = NSNumberFormatter()
        nf.numberStyle = .CurrencyStyle
        return nf.stringFromNumber(self)!
    }
}
