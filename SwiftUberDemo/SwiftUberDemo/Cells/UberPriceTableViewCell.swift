//
//  UberPriceTableViewCell.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/18/15.
//  Copyright © 2015 Sean Wilson. All rights reserved.
//

import UIKit

class UberPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var estimate: UILabel?
    @IBOutlet weak var lowEstimate: UILabel?
    @IBOutlet weak var highEstimate: UILabel?
    @IBOutlet weak var surgeMultipler: UILabel?
    @IBOutlet weak var duration: UILabel?
    @IBOutlet weak var distance: UILabel?
    
    var _uberRidePrice: UberPrice?
    var uberRidePrice: UberPrice? {
        get {
            if let price = _uberRidePrice as UberPrice? {
                return price
            }
            return nil
        }
        set (value) {
            self.resetData()
            if let price = value as UberPrice? {
                _uberRidePrice = price
                
                if let priceEstimate = price.estimate as String? {
                    estimate?.text = "Estimate: " + priceEstimate
                }
                
                if let priceLowEstimate = price.lowEstimate as Int? {
                    lowEstimate?.text = "Low Estimate: " + priceLowEstimate.toCurrency()
                }
                
                if let priceHighEstimate = price.highEstimate as Int? {
                    highEstimate?.text = "High Estimate: " + priceHighEstimate.toCurrency()
                }
                
                if let priceSurge = price.surgeMultiplier as Float? {
                    surgeMultipler?.text = "Surge: " + String(priceSurge)
                }
                
                if let priceDuration = price.duration as Int? {
                    duration?.text = "Time To Destination: " + String(priceDuration.secondsToMinutes())
                }
                
                if let priceDistance = price.distance as Float? {
                    distance?.text = "Distance: " + String(priceDistance)
                }
                
            }
        }
    }
    
    func resetData() {
        estimate?.text = " Estimate: "
        lowEstimate?.text = "Low Estimate: "
        highEstimate?.text = "High Estimate: "
        surgeMultipler?.text = "Surge: "
        duration?.text = "Time To Destination: "
        distance?.text = "Distance: "
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
