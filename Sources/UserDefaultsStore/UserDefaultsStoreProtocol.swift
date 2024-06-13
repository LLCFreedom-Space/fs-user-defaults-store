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
//  UserDefaultsStoreProtocol.swift
//
//
//  Created by Mykola Buhaiov on 21.07.2022.
//

import Foundation

/// A protocol defining methods for interacting with UserDefaults to store and retrieve data.
public protocol UserDefaultsStoreProtocol {
    /// Stores a Codable value for a given key.
    ///
    /// - Parameters:
    ///   - value: The value to be stored.
    ///   - forKey: The key to associate with the value.
    func set<T: Codable>(_ value: T, forKey: String)
    
    /// Retrieves a Codable value for a given key.
    ///
    /// - Parameter defaultName: The key associated with the value.
    /// - Returns: The stored value, or nil if no value is found for the key.
    func get<T: Codable>(forKey defaultName: String) -> T?
    
    /// Retrieves an array of Codable values for a given key.
    ///
    /// - Parameter defaultName: The key associated with the array.
    /// - Returns: The array of stored values, or an empty array if no values are found.
    func array<T: Codable>(forKey defaultName: String) -> [T]

    /// Removes the value associated with a given key.
    ///
    /// - Parameter defaultName: The key of the value to remove.
    func remove(forKey defaultName: String)
    
    /// Stores a Codable object for a given key using encoding.
    ///
    /// - Parameters:
    ///   - object: The object to be stored.
    ///   - forKey: The key to associate with the object.
    /// - Throws: An error if encoding fails.
    func saveObject<T: Codable>(_ object: T, forKey: String)
    
    /// Retrieves a Codable object for a given key using decoding.
    ///
    /// - Parameters:
    ///   - defaultName: The key associated with the object.
    ///   - type: The expected type of the object.
    /// - Returns: The decoded object, or nil if decoding fails or no object is found.
    func getObject<T: Codable>(forKey defaultName: String, castTo type: T.Type) -> T?
    
    /// Returns all keys which are present in the store.
    ///
    /// - Returns: The array of `String` representing all keys from the store.
    func keys() -> [String]
    
    /// Resets the UserDefaults store to its initial state, removing all stored values.
    func reset()
    
    /// Removes all stored values except for those specified in the keys array.
    ///
    /// - Parameter keys: An array of keys to preserve.
    func clean(except keys: [String])
}
