//
//  ProductOverviewTableViewCell.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/13/15.
//  Copyright © 2015 Sean Wilson. All rights reserved.
//

import UIKit

class ProductOverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel?
    @IBOutlet weak var productDescription: UILabel?
    @IBOutlet weak var capacity: UILabel?
    @IBOutlet weak var productId: UILabel?
    
    var _product:UberProduct?
    var product:UberProduct? {
        get {
            if let uberProduct = _product as UberProduct? {
                return uberProduct
            }
            return nil
        }
        set (value) {
            self.resetValues()
            if let uberProduct = value as UberProduct? {
                _product = uberProduct
                
                if let name = uberProduct.displayName as String? {
                    self.productName?.text = name
                }
                
                if let description = uberProduct.productDescription as String? {
                    self.productDescription?.text = description
                }
                
                if let riders = uberProduct.capacity as Int? {
                    self.capacity?.text = "Capacity: \(riders)"
                }
                
                self.productId?.text = "Product Id: \(uberProduct.id)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetValues() {
        self.productName?.text = ""
        self.productDescription?.text = ""
        self.capacity?.text = "Capacity: "
    }
    
}
