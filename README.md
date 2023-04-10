# iOSfunctions-SDK #

# Overview
 iOSfunctions-SDK is a framework that contains encapsulated services, managers, singletons and related files (models, viewModels, extensions, global constants and functions):

Files for interacting with API:

* RestManager - contains API requests related to the user session, VTO usage and the ability to create orders, get countries and collections

* RestClientV3 - contains API requests related to making, closing and uploading orders; attaching scan, photo and screenshot. 

Managers:

* DataManager - for managing collection data

* DownloaderManager - for giving status about downloading

* ConnectionManager - for checking internet connectivity

* LoginManager - for managing user session 

* UserManager - for managing user’s settings

* SavingManager - for storing data locally on the device 

Singletons:

* CollectionsSingleton - contains data about collections, has an interface for saving, deleting, reading, filtering collections and products

* OrderQueueSingleton - contains an interface for CRUD orders


# Development environment:
Xcode 13 or later
# Setup project
1. Download the project from https://bitbucket.org/youmawo/iosfunctions-sdk/src/FIRST_DISTRIBUTOR/
2. Install pods using pod install (on M1 & M2 arch -x86_64 pod install)

# Deployment instructions
1. Open iOSfunctions.xcworkspace
2. Select “Any iOS Device (arm64)” as the build destination
3. Build the active scheme

# Framework installation in the project
1. In the project's folder Products find the iOSFunctions framework file
2. Open the iOSFunctions framework file in the finder using 'Show in Finder' in Xcode - we can see the iOSfunctions.framework folder in Finder
3. Copy the iOSfunctions.framework folder and paste it to the core projects folder (the same folder where .xcodeproj is located)
4. Copy and paste other frameworks (automatically generated from pods) into the core project (you can create a separate folder for them). The frameworks are:
* AFNetworking
* CocoaLumberjack
* Connectivity
* Differentiator
* Realm
* RealmSwift
* RxCocoa
* RxDataSources
* RxRelay
* RxSwift
* SharedWebCredentials
5. Open the project’s target -> Buid Phases and add all these frameworks to the Embed Frameworks 

# Usage
For interacting with iOSfunctions-SDK framework you should import it in the file using 
import iOSfunctions:

	import iOSfunctions

	class OrderInformationViewController: UIViewController { ... }

 After importing the iOSfunctions-SDK framework you can use any resources from the framework similar to resources in the core project:

	if LoginManager.standardLoginManager().isUserAllowedToUseVTO {
		print(“isUserAllowedToUseVTO”)
	}



