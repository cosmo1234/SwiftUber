//
//  ProductViewController.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/8/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var swiftUber: SwiftUber!
    var product:UberProduct!
    var ride: UberRide!
    // Replace with your own!! 
    let swiftUberClientId = "DCyBiqd7ngKYw7Pw4AlnSgw9JPqLIKGy"
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var openUberButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product View"
        self.setUpTableView()

        // Do any additional setup after loading the view.
        
        self.swiftUber.priceEstimate(self.ride, completion: {
            (products: [UberProduct], error: NSError?) -> Void in
            self.tableView?.reloadData()
            for product in products {
                // name: product.displayName (String?)
                // priceEstimate: product.uberPrice?.estimate (String?)
                print("product Name: \(product.displayName) | price Estimate: \(product.uberPrice?.estimate)")
            }
            
        })
        
        self.openUberButton?.setTitle("Open Uber", forState: UIControlState.Normal)

    }
    
    func setUpTableView() {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView?.registerNib(UINib(nibName: "ProductOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductOverviewTableViewCell")
        self.tableView?.registerNib(UINib(nibName: "PriceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceDetailsTableViewCell")
        self.tableView?.registerNib(UINib(nibName: "ServiceFeeTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceFeeTableViewCell")
        self.tableView?.registerNib(UINib(nibName: "UberPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "UberPriceTableViewCell")
        
        self.tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 1
        
        if let _ = self.product.priceDetails as PriceDetail? {
            count += 1
        }
        
        if let _ = self.product.uberPrice as UberPrice? {
            count += 1
        }
        
        print("count: \(count)")
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if let details = self.product.priceDetails as PriceDetail? {
                return details.serviceFees.count + 1
            }
            return 0
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row){
        case (0,0):
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductOverviewTableViewCell", forIndexPath: indexPath) as! ProductOverviewTableViewCell
            cell.product = self.product
            return cell
        case (1,0):
            let cell = tableView.dequeueReusableCellWithIdentifier("PriceDetailsTableViewCell", forIndexPath: indexPath) as! PriceDetailsTableViewCell
            cell.priceDetail = self.product.priceDetails
            return cell
        case (1,_) where indexPath.row > 0 :
            let cell = tableView.dequeueReusableCellWithIdentifier("ServiceFeeTableViewCell", forIndexPath: indexPath) as! ServiceFeeTableViewCell
            cell.serviceFee = self.product.priceDetails?.serviceFees[indexPath.row - 1]
            return cell
        case (2,_):
            let cell = tableView.dequeueReusableCellWithIdentifier("UberPriceTableViewCell", forIndexPath: indexPath) as! UberPriceTableViewCell
            cell.uberRidePrice = self.product.uberPrice
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case(0,0): return 90
        case(1,0): return 130
        case(1,_) where indexPath.row > 0: return 45
        default: return 0
        }
    }
    

    // MARK : Open Uber
    @IBAction func openUber() {
        self.ride.uberProduct = self.product
        self.swiftUber.openUber(self.ride, clientId: swiftUberClientId)
    }

}
