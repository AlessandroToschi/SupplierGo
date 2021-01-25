#  SupplierGo

## Contents
- SupplierGo: iOS App.
- SupplierGoKit: the framework containing the Supplier's model.
- SupplierGoKitTests: the Unit Tests of the SupplierGoKit model.

### SupplierGo
The SupplierGo App is composed of two main views: the SupplierTableViewController and the SupplierDetailViewControler.
The first is the entry point of the App, downloads the suppliers from the endpoint and presents the most important information in a UITableView: name, company and avatar. 

The download of the avatars has been decoupled from the download of the suppliers.
This choice is motivated by the fact that the avatar is just a part of the supplier, so it can be loaded and rendered in a second time.
This is especially true in case of slow network, where the App could be stucked while downloading the avatars and yet not having presented any content to the user.

If the user selects a supplier, then it is modally pushed a card containing all the information of the supplier.
The card can be dismissed using a swipe from top to bottom.
The card is implemented as a **transparent** view controller, and then, using stack views and autolayout, it is presented a solid view containing the supplier's information.

### SupplierGoKit
The SupplierGoKit contains the model of the App, and it is arranged as a separate target from the App.

The Supplier struct contains all the attributes described in the requirements and conforms the Decodable protocol, so it can be deserialized from JSON data since the API returns a JSON. However, the decoding has been explicitly implemented because I have chosen to model the Avatar as a separete structure, containing both the endpoint and the data of the image, without being constrained to a specific platform/framework container (UIImage, CIImage, CGImage, NSImage, etc, etc).

The DataLoader struct defines a primitive way of downloading data from an endpoint. It is in charge also of handling first level errors related to network or response. The callback is called asynchronously.

The SupplierLoader is class that contains an array of suppliers, and download and deserialize them from the given endpoint and data.
It is also in charge of downloading the avatars of the suppliers, once loaded.

### SupplierGoKitTests
The Unit Tests are focused on the model instead of the App.
The tests are stressing the network part of the DataLoader and the right decoding of a supplier, given different JSON files.

The Live folder contains a live demo of this App on my iPhone :D
