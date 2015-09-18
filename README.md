# SwiftUber
##Easy Uber integration for Swift.

Just started. Cocoa Pods coming soon. 

To install, download zip and add files from the SwiftUberSource Folder to your Project.
Demo project also attached, feel free to play around there.

To use:
```
initialize SwiftUber with your Uber Server token:
let swiftUber = UberSwift(serverToken: "servertoken"
```
At the center of this is the UberRide. This object stores where the user is and where they are going.
```
let ride = UberRide(pickupLocation: CLLocation)
ride.dropOffLocation = destination
ride.setDestinationAddress(address: "Destination's Full Address", completion: nil)
```

###Use Case: Give user price estimates & open Uber

Initialize UberSwift
```
let swiftUber = UberSwift(serverToken: "servertoken")
```
Create Ride
```
let ride = UberRide(pickupLocation: CLLocation)
ride.dropOffLocation = destination
ride.setDestinationAddress(address: "Destination's Full Address", completion: nil)
```
Get Uber Price Estimates
```
swiftUber.priceEstimate(ride: ride, completion {
	(products: [UberProduct], error: NSError?) -> Void in
	for product in products {
		// name: product.displayName (String?)
		// priceEstimate: product.uberPrice?.estimate (String?)
	}
})
```
User Picks Uber Price (UberProduct is already attached)
ride.uberProduct = price.uberProduct

Open up In App
```
swiftUber.openUber(ride: ride, clientId: "yourClientId")
```
This will try to open in Uber app first. If app is not on phone, it will open up safari.

###Current Functions:
 - allProducts(location: CLLocation, completion: (([UberProduct], NSError?) -> Void)?) 
 	- Returns a list of all available uber products in a region
 - priceEstimate(ride: UberRide, completion: (([UberProduct], NSError?) -> Void)?)
 	- This returns a list of UberProducts. Prices are attached to products as .uberPrices. Requires an UberRide.
 - openUber(ride: UberRide, clientId:String)
 	- If the user has the Uber app, the app will open, otherwise this opens Safari for them to sign up ... where you get your referal credits. Requres a ride w/ a destination and your clientId. 
