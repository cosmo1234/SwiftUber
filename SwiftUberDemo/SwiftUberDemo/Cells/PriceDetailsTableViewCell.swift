//
//  PriceDetailsTableViewCell.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/13/15.
//  Copyright © 2015 Sean Wilson. All rights reserved.
//

import UIKit

class PriceDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceUnit: UILabel?
    @IBOutlet weak var currenceCode: UILabel?
    @IBOutlet weak var base:UILabel?
    @IBOutlet weak var costPerDistance: UILabel?
    @IBOutlet weak var costPerMinute: UILabel?
    @IBOutlet weak var cancellationFee: UILabel?
    @IBOutlet weak var minimum:UILabel?
    
    var _priceDetail: PriceDetail?
    var priceDetail: PriceDetail? {
        get {
            if let detail = _priceDetail as PriceDetail? {
                return detail
            }
            return nil
        }
        set (value) {
            self.resetValues()
            if let detail = value as PriceDetail? {
                _priceDetail = detail
                
                
                if let distance_unit = detail.distanceUnit as String? {
                    self.distanceUnit?.text = "Distance Unit: \(distance_unit)"
                }
                
                if let currence = detail.currencyCode as String? {
                    self.currenceCode?.text = "Currency Code: \(currence)"
                }
                
                if let baseFare = detail.base as Float? {
                    self.base?.text = "Base Fare: \(baseFare.toCurrency())"
                }
                
                if let cpd = detail.costPerDistance as Float? {
                    self.costPerDistance?.text = "Cost Per Distance: \(cpd.toCurrency())"
                }
                
                if let cpm = detail.costPerMinute as Float? {
                    self.costPerMinute?.text = "Cost Per Minute: \(cpm.toCurrency())"
                }
                
                if let cancelFee = detail.cancellationFee as Float? {
                    self.cancellationFee?.text = "Cancellation Fee: \(cancelFee.toCurrency())"
                }
                
                if let min = detail.minimum as Float? {
                    self.minimum?.text = "Minimum Cost: \(min.toCurrency())"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetValues() {
        self.distanceUnit?.text = "Distance Unit:"
        self.currenceCode?.text = "Currency Code:"
        self.base?.text = "Base Fare:"
        self.costPerDistance?.text = "Cost Per Distance:"
        self.costPerMinute?.text = "Cost Per Minute:"
        self.cancellationFee?.text = "Cancellation Fee:"
        self.minimum?.text = "Minimum Cost:"
    }
    
}
