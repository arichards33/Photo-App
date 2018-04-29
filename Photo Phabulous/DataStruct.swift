//
//  DataStruct.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/22/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//

import Foundation

struct Pictures: Codable {
    var results: [Pic]
}

struct Pic: Codable {
    var date: String?
    var caption: String?
    var image_url: String?
    var user: String?
}
