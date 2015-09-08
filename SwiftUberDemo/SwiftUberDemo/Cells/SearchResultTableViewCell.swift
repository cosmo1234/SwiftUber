//
//  SearchResultTableViewCell.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var address: UILabel?
    
    var _mapItem:MKMapItem?
    var mapItem: MKMapItem? {
        get {
            if let item = _mapItem as MKMapItem? {
                return item
            }
            return nil
        }
        set(value) {
            if let item = value as MKMapItem? {
                _mapItem = item
                
                name?.text = item.name
                address?.text = item.placemark.title
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
    
}
