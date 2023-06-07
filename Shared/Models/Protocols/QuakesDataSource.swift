//
//  QuakesDataSource.swift
//  Earthquakes-iOS
//
//  Created by Tomasz Lizer on 07/06/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

protocol QuakesDataSource {
    var quakes: [Quake] { get }
}
