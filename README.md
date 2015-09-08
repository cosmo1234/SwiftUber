# SwiftUber
##Easy Uber integration for Swift.

Just started. Cocoa Pods coming soon. 

To install, download zip and add files from the SwiftUberSource Folder to your Project.
Demo project also attached, feel free to play around there.

To use:

initialize SwiftUber with your Uber Server token:
let swiftUber = UberSwift(serverToken: "servertoken"

At the center of this is the UberRide. This object stores where the user is and where they are going.

let ride = UberRide(pickupLocation: CLLocation)
ride.dropOffLocation = destination
ride.nickName = destinationName


Use Case: Give user Uber Price estimates & open Uber
Initialize UberSwift
let swiftUber = UberSwift(serverToken: "servertoken")

Create Ride
let ride = UberRide(pickupLocation: CLLocation)
ride.dropOffLocation = destination
ride.nickName = destinationName

Get Uber Price Estimates
swiftUber.priceEstimate(ride: ride, completion {
	(prices: [UberPrice]?, error: NSError?) -> Void in
	if let uberPrices = prices as [UberPrice]? {
		// display estimate & names
		for price in uberPrices {
			// name: price.displayName (String?)
			// estimate: price.estimate (String?)
		}
	}
})

User Picks Uber Price (UberProduct is already attached)
ride.uberProduct = price.uberProduct

Open up In App
swiftUber.openUber(ride: ride, clientId: "yourClientId")
// This will try to open in Uber app first. If app is not on phone, it will open up safari.

Current Functions:
 - priceEstimate(ride: UberRide, completion: (([UberPrice]?, NSError?) -> Void)?)
      This returns a list of price estimates. Attaches to Products. Requires an UberRide to call
 - openUber(ride: UberRide, clientId:String)
      If the user has the Uber app, the app will open, otherwise this opens Safari for them to sign up ... where you get your referal credits. Requres a ride w/ a destination and your clientId. 
