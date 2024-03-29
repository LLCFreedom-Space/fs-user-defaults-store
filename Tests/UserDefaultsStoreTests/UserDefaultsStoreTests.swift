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
//  UserDefaultsStoreTests.swift
//
//
//  Created by Mykhailo Bondarenko on 28.01.2024.
//

import Foundation
import XCTest
@testable import UserDefaultsStore

final class UserDefaultsStoreTests: XCTestCase {
    /// A private variable to store the `UserDefaultsStore` instance.
    private var userDefaults: UserDefaultsStore?
    
    /// Sets up the test environment before each test.
    override func setUp() {
        super.setUp()
        userDefaults?.reset()
    }
    
    /// Cleans up the test environment after each test.
    override func tearDown() {
        super.tearDown()
        userDefaults?.reset()
    }
    
    /// Tests creating a `UserDefaultsStore` instance with a specified suite name.
    func testCreateStore() {
        let suiteName = UUID().uuidString
        let store = createStore(suiteName: suiteName)
        XCTAssertEqual(store.suiteName, suiteName)
    }
    
    /// Tests setting string values for different keys and verifies retrieval.
    func testSet() {
        let store = createStore()
        let value = "foo"
        let value2 = "bar"
        let key = "KEY_1"
        let key2 = "KEY_2"
        store.set(value, forKey: key)
        XCTAssertEqual(store.get(forKey: key), value)
        
        store.set(value2, forKey: key)
        XCTAssertEqual(store.get(forKey: key), value2)
        
        store.set(value, forKey: key2)
        XCTAssertEqual(store.get(forKey: key2), value)
        XCTAssertEqual(store.get(forKey: key), value2)
    }
    
    /// Tests saving and retrieving `Codable` objects using JSON encoding/decoding.
    func testSetObject() throws {
        let store = createStore()
        let key = "KEY_1"
        store.set(try JSONEncoder().encode(MockObject.foo), forKey: key)
        let data: Data = try XCTUnwrap(store.get(forKey: key))
        let storeValue = try JSONDecoder().decode(MockObject.self, from: data)
        XCTAssertEqual(storeValue, MockObject.foo)
        
        store.set(try JSONEncoder().encode(MockObject.bar), forKey: key)
        let data2: Data = try XCTUnwrap(store.get(forKey: key))
        let storeValue2 = try JSONDecoder().decode(MockObject.self, from: data2)
        XCTAssertEqual(storeValue2, MockObject.bar)
    }
    
    /// Tests storing and retrieving string arrays.
    func testSetArray() throws {
        let store = createStore()
        let value = ["foo", "bar"]
        let key = "KEY_1"
        
        store.set(value, forKey: key)
        let array = store.userDefaults.array(forKey: key) as? [String]
        XCTAssertNotNil(array)
        XCTAssertEqual(array, value)
        store.userDefaults.set([], forKey: key)
        let storageValue: [String] = try XCTUnwrap(store.array(forKey: key))
        XCTAssertTrue(storageValue.isEmpty)
    }
    
    /// Tests removing a specific key-value pair.
    func testRemove() throws {
        let store = createStore()
        let value = "foo"
        let key = "KEY_1"
        
        store.userDefaults.set(value, forKey: key)
        let storageValue = store.userDefaults.object(forKey: key) as? String
        XCTAssertNotNil(storageValue)
        
        store.remove(forKey: key)
        let result = store.userDefaults.object(forKey: key) as? String
        XCTAssertNil(result)
    }
    
    /// Tests resetting the entire `UserDefaults` store.
    func testReset() throws {
        let store = createStore()
        let value = "foo"
        let key = "KEY_1"
        
        // Prepare UserDefaults
        let initialSutStorage = store.userDefaults.dictionaryRepresentation()
        store.userDefaults.set(value, forKey: key)
        let sutStorage = store.userDefaults.dictionaryRepresentation()
        XCTAssertLessThan(initialSutStorage.count, sutStorage.count)
        
        let fooValueFromStorage = store.userDefaults.object(forKey: key) as? String
        XCTAssertEqual(fooValueFromStorage, value)
        
        store.reset()
        let checkSutStorage = store.userDefaults.dictionaryRepresentation()
        XCTAssertLessThan(checkSutStorage.count, sutStorage.count)
        
        let valueAfterReset = store.userDefaults.object(forKey: key) as? String
        XCTAssertNil(valueAfterReset)
    }
    
    /// Tests selectively cleaning up UserDefaults while preserving values for specified keys.
    func testCleanExcept() {
        let store = createStore()
        let value = "foo"
        let key = "KEY_1"
        let value2 = "bar"
        let key2 = "KEY_2"
        
        let initialSutStorage = store.userDefaults.dictionaryRepresentation()
        store.userDefaults.set(value, forKey: key)
        store.userDefaults.set(value2, forKey: key2)
        let sutStorage = store.userDefaults.dictionaryRepresentation()
        XCTAssertLessThan(initialSutStorage.count, sutStorage.count)
        
        store.clean(except: [key2])
        let checkSutStorage = store.userDefaults.dictionaryRepresentation()
        XCTAssertLessThan(checkSutStorage.count, sutStorage.count)
        
        let valueAfterReset = store.userDefaults.object(forKey: key) as? String
        XCTAssertNil(valueAfterReset)
        let value2AfterReset = store.userDefaults.object(forKey: key2) as? String
        XCTAssertEqual(value2AfterReset, value2)
    }
    
    /// Tests saving and retrieving `Codable` objects using a dedicated method.
    func testSave() throws {
        let store = createStore()
        let key = "KEY_1"
        store.saveObject(MockObject.foo, forKey: key)
        let storeValue = try XCTUnwrap(store.getObject(forKey: key, castTo: MockObject.self))
        XCTAssertEqual(storeValue, MockObject.foo)
        
        store.saveObject(MockObject.bar, forKey: key)
        let storeValue2 = try XCTUnwrap(store.getObject(forKey: key, castTo: MockObject.self))
        XCTAssertEqual(storeValue2, MockObject.bar)
    }
}

/// Private helper function to create a `UserDefaultsStore` instance with a specified suite name.
private extension UserDefaultsStoreTests {
    /// Creates a `UserDefaultsStore` instance with a specified suite name.
    ///
    /// - Parameter suiteName: The name of the suite to use for the UserDefaults store. Defaults to "user".
    /// - Returns: A new `UserDefaultsStore` instance.
    func createStore(
        suiteName: String = "user"
    ) -> UserDefaultsStore {
        let userDefaults = UserDefaultsStore(suiteName: suiteName)
        XCTAssertEqual(suiteName, userDefaults.suiteName)
        userDefaults.reset()
        self.userDefaults = userDefaults
        return userDefaults
    }
}
