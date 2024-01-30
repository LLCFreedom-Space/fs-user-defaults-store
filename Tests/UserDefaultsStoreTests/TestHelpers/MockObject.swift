// FS Dependency Injection
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
//  MockObject.swift
//
//
//  Created by Mykhailo Bondarenko on 28.01.2024.
//

import Foundation

struct MockObject: Codable {
    let id: Int
    var name: String
}

extension MockObject: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MockObject {
    static let foo = Self(id: 1, name: "Foo")
    static let bar = Self(id: 2, name: "Bar")
    static let baz = Self(id: 3, name: "Baz")
}
