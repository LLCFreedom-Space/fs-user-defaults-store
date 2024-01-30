# FSUserDefaultsStore

Thread-Safe Codable Storage for Swift

A powerful wrapper around UserDefaults that provides:

* Thread-safe storage and retrieval of Codable data.
* Convenient methods for storing and retrieving objects as JSON.
* Data management features, including resetting and selective cleaning.
* Support for multiple UserDefaults stores using suite names.

## Key Features:

* Thread Safety: Ensures data integrity in multithreaded environments using a recursive lock.
* Codable Support: Seamlessly stores and retrieves Codable values and objects.
* JSON Encoding/Decoding: Handles object storage and retrieval using JSONEncoder and JSONDecoder.
* Suite Name Support: Manages multiple UserDefaults stores for different namespaces.
* Data Management: Provides methods for resetting the store, selective cleaning, and removing individual values.

## Installation:

Add the package to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/your-username/FSUserDefaultsStore", from: "1.0.0")
]
```
Import the package in your Swift files:
```swift
import UserDefaultsStore
```

## Usage:

Create a store instance:
```swift
let store = UserDefaultsStore(suiteName: "myAppSuite")
```

Store and retrieve values:
```swift
// Store a string
store.set("Hello, UserDefaultsStore!", forKey: "myString")

// Retrieve the string
let retrievedString = store.get(forKey: "myString") as? String
```

Store and retrieve objects:
```swift
struct User: Codable {
let name: String
let age: Int
}

// Store a User object
let user = User(name: "John Doe", age: 30)
store.saveObject(user, forKey: "user")

// Retrieve the User object
let retrievedUser = store.getObject(forKey: "user", castTo: User.self)
```

For more detailed usage and examples, please refer to the documentation within the package.

## Contribute:

We welcome contributions to this project! Please feel free to open issues or pull requests to help improve the package.


