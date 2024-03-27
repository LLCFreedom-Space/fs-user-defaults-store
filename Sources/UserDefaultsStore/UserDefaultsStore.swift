// FS User Defaults Store
// Copyright (C) 2023  FREEDOM SPACE, LLC

//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  UserDefaultsStore.swift
//
//
//  Created by Mykhailo Bondarenko on 11.07.2022.
//

import Foundation

/// A thread-safe wrapper around UserDefaults, providing Codable storage and management features.
public struct UserDefaultsStore: UserDefaultsStoreProtocol {
    /// A recursive lock to ensure thread safety.
    let lock = NSRecursiveLock()
    
    /// The underlying UserDefaults instance.
    let userDefaults: UserDefaults
    
    /// The suite name associated with this store.
    public let suiteName: String
    
    /// Initializes a new UserDefaultsStore with the given suite name.
    ///
    /// - Parameter suiteName: The suite name to use for the store.
    public init(suiteName: String) {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            preconditionFailure("UserDefaults not initialized with suiteName \(suiteName)")
        }
        self.userDefaults = userDefaults
        self.suiteName = suiteName
    }
    
    // MARK: - Codable Storage

    /// Stores a Codable value for a given key.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - forKey: The key to associate with the value.
    public func set<T: Codable>(_ value: T, forKey: String) {
        sync {
            userDefaults.set(value, forKey: forKey)
        }
    }
    
    /// Retrieves a Codable value for a given key.
    ///
    /// - Parameter defaultName: The key associated with the value.
    /// - Returns: The stored value, or nil if no value is found for the key.
    public func get<T: Codable>(forKey defaultName: String) -> T? {
        userDefaults.object(forKey: defaultName) as? T
    }
    
    /// Retrieves an array of Codable values for a given key.
    ///
    /// - Parameter defaultName: The key associated with the array.
    /// - Returns: The array of stored values, or an empty array if no values are found.
    public func array<T: Codable>(forKey defaultName: String) -> [T] {
        userDefaults.array(forKey: defaultName) as? [T] ?? []
    }
    
    // MARK: - Object Storage

    /// Stores a Codable object for a given key using encoding.
    ///
    /// - Parameters:
    ///   - object: The object to store.
    ///   - forKey: The key to associate with the object.
    public func saveObject<T: Codable>(_ object: T, forKey: String) {
        sync {
            guard let data = try? JSONEncoder().encode(object) else {
                userDefaults.removeObject(forKey: forKey)
                return
            }
            userDefaults.set(data, forKey: forKey)
        }
    }
    
    /// Retrieves a Codable object for a given key using decoding.
    ///
    /// - Parameters:
    ///   - defaultName: The key associated with the object.
    ///   - type: The expected type of the object.
    /// - Returns: The decoded object, or nil if decoding fails or no object is found.
    public func getObject<T: Codable>(forKey defaultName: String, castTo type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: defaultName) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: - Data Management

    /// Removes the value associated with a given key.
    ///
    /// - Parameter defaultName: The key of the value to remove.
    public func remove(forKey defaultName: String) {
        sync {
            userDefaults.removeObject(forKey: defaultName)
        }
    }
    
    /// Resets the UserDefaults store to its initial state, removing all stored values.
    public func reset() {
        sync {
            userDefaults.removePersistentDomain(forName: suiteName)
            userDefaults.removeSuite(named: suiteName)
        }
    }
    
    /// Removes all stored values except for those specified in the `keys` array.
    ///
    /// This method provides a way to selectively clean up the UserDefaults store, preserving specific values while removing others.
    ///
    /// - Parameter keys: An array of keys that should be preserved. All other values will be removed.
    public func clean(except keys: [String]) {
        sync {
            let dictionary = userDefaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                // Stored values that shouldn't be reseted
                if keys.contains(key) {
                    return
                }
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
