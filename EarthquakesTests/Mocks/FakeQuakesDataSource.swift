//
//  FakeQuakesDataSource.swift
//  EarthquakesTests
//
//  Created by Tomasz Lizer on 07/06/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
@testable import Earthquakes

final class FakeQuakesDataSource: QuakesDataSource {
    var mockedQuakes: [Quake] = []
    
    var quakes: [Quake] {
        mockedQuakes
    }
}
