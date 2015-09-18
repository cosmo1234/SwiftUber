//
//  ViewController.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
    
    var searchResults: [MKMapItem] = []
    var shouldUpdateLocation: Bool = true
    var searchingForLocations = false
    
    let cellHeight:CGFloat = 40
    
    // REPLACE WITH YOUR OWN SERVER TOKEN & ClIENT ID
    var ride: UberRide?
    let swiftUber = SwiftUber(serverToken: "gS4stVsPMm9dThCPpXWBdhDzEhPkMb0BcruNbelO")
    let swiftUberClientId = "DCyBiqd7ngKYw7Pw4AlnSgw9JPqLIKGy"
    var prices:[UberPrice] = []
    var products: [UberProduct] = []
    
    // Search Result
    var searchText = ""
    var searchTimer: NSTimer = NSTimer()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setUpNotifications()
        self.setUpMapView()
        self.setUpTableView()
        
        self.textField?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("searchForLocation"), name: UITextFieldTextDidChangeNotification, object: self.textField)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLocation", name: "locationUpdated", object: nil)
    }
    
    func setUpMapView() {
        self.mapView?.delegate = self
        LocationManager.sharedInstance.start()
        if LocationManager.sharedInstance.enabled {
            self.mapView?.showsUserLocation = true
        }
    }
    
    func setUpTableView() {
        self.tableView?.registerNib(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        self.tableView?.hidden = true
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.setTableViewHeight()
    }
    
    // Search Results
    func searchForLocation() {
        self.searchTimer.invalidate()
        
        if self.textField?.text == "" {
            self.tableView?.hidden = true
            self.shouldUpdateLocation = true
            return
        }
        
        if let text = self.textField?.text as String? {
            self.searchingForLocations = true
            searchText = text
            //self.searchTimer
            self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "delayedSearch", userInfo: nil, repeats: false)
        }
    }
    
    func delayedSearch() {
        print("search text = \(searchText) | textField: \(self.textField?.text)")
        
        if searchText == self.textField?.text {
            LocalSearchManager.search(searchText, region: self.mapView?.region, completion: {
                (mapItems: [MKMapItem], error: NSError?) -> Void in
                print("search results: \(mapItems)")
                self.searchResults = mapItems
                self.searchingForLocations = false
                self.tableView?.hidden = false
                self.setTableViewHeight()
                self.tableView?.reloadData()
            })
        }
    }
    
    func setTableViewHeight() {
        
        UITableView.animateWithDuration(0.23, animations: {
            self.tableViewHeight?.constant = CGFloat(self.searchResults.count) * self.cellHeight
            self.view.layoutIfNeeded()
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultTableViewCell", forIndexPath: indexPath) as! SearchResultTableViewCell
        cell.mapItem = searchResults[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.textField?.isFirstResponder() == true {
            self.textField?.resignFirstResponder()
        }
        
        if !self.searchingForLocations {
            let mapItem = self.searchResults[indexPath.row]
            self.launchUberOptions(mapItem)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Current Location Listener
    
    func updateLocation() {
        if self.shouldUpdateLocation == false {
            return
        }
        
        if let location = LocationManager.sharedInstance.currentLocation as CLLocation? {
            //print("location \(location)")
            self.mapView?.setCenterCoordinate(location.coordinate, animated: true)
            let viewRegion = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(viewRegion, 1000, 1000)
            self.mapView?.setRegion(region, animated: true)
            self.mapView?.showsUserLocation = true
        }
    }
    
    
    // UBER Logic
    
    func launchUberOptions(mapItem: MKMapItem) {
        if let location = LocationManager.sharedInstance.currentLocation as CLLocation? {
            self.ride = UberRide(pickupLocation: location)
            self.ride?.dropOffLocation = mapItem.placemark.location
            if let title = mapItem.placemark.title as String? {
                self.ride?.setDestinationAddress(address: title, completion: nil)
            }
            
            
            self.swiftUber.allProducts(location, completion: {
                (uberProducts: [UberProduct], error: NSError?) -> Void in
                self.products = uberProducts
                self.displayUberProductActionSheet(uberProducts)
                
            })
        
        }
    }
    
    func displayUberProductActionSheet(uberProducts: [UberProduct]) {
        if uberProducts.count > 0 {
            let sheet = UIActionSheet(title: "Uber Products", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            for product in uberProducts {
                if let name = product.displayName as String? {
                    sheet.addButtonWithTitle(name)
                }
            }
            sheet.showInView(self.view)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex > 0 {
            let product = self.products[buttonIndex - 1]
            self.pushToProductViewController(product)
        }
    }
    
    func pushToProductViewController(product: UberProduct) {
        if let ride = self.ride as UberRide? {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
            controller.product = product
            controller.ride = ride
            controller.swiftUber = self.swiftUber
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}

