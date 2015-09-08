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

Current Functions:
 - allProducts(location: CLLocation, completion: (([UberProduct], NSError?) -> Void)?) 
      This returns a list of uberProducts 
 - priceEstimate(ride: UberRide, completion: (([UberPrice]?, NSError?) -> Void)?)
      This returns a list of price estimates. Attaches to Products. Requires an UberRide to call
 - openUber(ride: UberRide, clientId:String)
      If the user has the Uber app, the app will open, otherwise this opens Safari for them to sign up ... where you get your referal credits. Requres a ride w/ a destination and your clientId. 
