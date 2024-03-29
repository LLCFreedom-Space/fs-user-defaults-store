# FSUserDefaultsStore

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
![GitHub release (with filter)](https://img.shields.io/github/v/release/LLCFreedom-Space/fs-user-defaults-store)
[![Read the Docs](https://readthedocs.org/projects/docs/badge/?version=latest)](https://llcfreedom-space.github.io/fs-user-defaults-store/)
![example workflow](https://github.com/LLCFreedom-Space/fs-user-defaults-store/actions/workflows/docc.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-user-defaults-store/actions/workflows/lint.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-user-defaults-store/actions/workflows/test.yml/badge.svg?branch=main)
[![codecov](https://codecov.io/github/LLCFreedom-Space/fs-user-defaults-store/graph/badge.svg?token=2EUIA4OGS9)](https://codecov.io/github/LLCFreedom-Space/fs-user-defaults-store)

Thread-Safe Codable Storage for Swift

A powerful wrapper around UserDefaults that provides:

* Thread-safe storage and retrieval of Codable data.
* Convenient methods for storing and retrieving objects as JSON.
* Data management features, including resetting and selective cleaning.
* Support for multiple UserDefaults stores using suite names.

## Key Features

* Thread Safety: Ensures data integrity in multithreaded environments using a recursive lock.
* Codable Support: Seamlessly stores and retrieves Codable values and objects.
* JSON Encoding/Decoding: Handles object storage and retrieval using JSONEncoder and JSONDecoder.
* Suite Name Support: Manages multiple UserDefaults stores for different namespaces.
* Data Management: Provides methods for resetting the store, selective cleaning, and removing individual values.

## Installation

Add the package to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/LLCFreedom-Space/fs-user-defaults-store", from: "1.0.0")
]
```

Import the package in your Swift files:

```swift
import UserDefaultsStore
```

## Usage

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

## Contribute

We welcome contributions to this project! Please feel free to open issues or pull requests to help improve the package.

## Links

LLC Freedom Space – [@LLCFreedomSpace](https://twitter.com/llcfreedomspace) – [support@freedomspace.company](mailto:support@freedomspace.company)

Distributed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3. See [LICENSE.md][license-url] for more information.

[GitHub](https://github.com/LLCFreedom-Space)

[swift-image]:https://img.shields.io/badge/swift-5.8-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-GPLv3-blue.svg
[license-url]: LICENSE
