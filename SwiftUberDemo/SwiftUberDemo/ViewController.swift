//
//  ViewController.swift
//  SwiftUberDemo
//
//  Created by Sean Wilson on 9/7/15.
//  Copyright (c) 2015 Sean Wilson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
    
    var searchResults: [MKMapItem] = []
    var shouldUpdateLocation: Bool = true
    var searchingForLocations = false
    
    let cellHeight:CGFloat = 40
    
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
        if self.textField?.text == "" {
            self.tableView?.hidden = true
            self.shouldUpdateLocation = true
            return
        }
        
        self.searchingForLocations = true
        if let searchText = self.textField?.text as String? {
            LocalSearchManager.search(searchText, region: self.mapView?.region, completion: {
                (mapItems: [MKMapItem], error: NSError?) -> Void in
                println("search results: \(mapItems)")
                self.searchResults = mapItems
                self.searchingForLocations = false
                self.tableView?.hidden = false
                self.setTableViewHeight()
                self.tableView?.reloadData()
            })
        }
        
    }
    
    func setTableViewHeight() {
        var height = 0
        
        
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
        
    }
    
    
}

