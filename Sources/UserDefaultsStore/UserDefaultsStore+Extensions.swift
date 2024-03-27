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
//  UserDefaultsStore+Extensions.swift
//
//
//  Created by Mykhailo Bondarenko on 29.01.2024.
//

import Foundation

internal extension UserDefaultsStore {
    /// Executes a closure within a lock to ensure thread safety.
    ///
    /// This method guarantees that only one thread can access the UserDefaults store at a time, preventing potential data corruption or inconsistencies.
    ///
    /// - Parameter action: The closure to execute within the lock.
    /// - Throws: Any error thrown by the `action` closure.
    func sync(action: () throws -> Void) rethrows {
        /// Acquires the lock, blocking other threads from accessing the store.
        lock.lock()
        /// Ensures the lock is released, even if an error occurs.
        defer { lock.unlock() }
        /// Executes the provided closure within the lock.
        try action()
    }
}
