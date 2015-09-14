//
//  ServiceFeeTableViewCell.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/13/15.
//  Copyright © 2015 Sean Wilson. All rights reserved.
//

import UIKit

class ServiceFeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var feeAmount: UILabel?
    
    var _serviceFee: ServiceFee?
    var serviceFee: ServiceFee? {
        get {
            if let fee = _serviceFee as ServiceFee? {
                return fee
            }
            return nil
        }
        set (value) {
            self.resetValues()
            if let fee = value as ServiceFee? {
                _serviceFee = fee
                
                if let title = fee.name as String? {
                    self.name?.text = "Fee Name: \(title)".capitalizedString
                }
                
                if let amount = fee.fee as Float? {
                    self.feeAmount?.text = "Fee Amount: \(amount.toCurrency())"
                }
            }
        }
        
    }
    
    func resetValues() {
        self.name?.text = "Fee Name:"
         self.feeAmount?.text = "Fee Amount:"
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
