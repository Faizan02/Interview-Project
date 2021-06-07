//
//  FlickerPhoto.swift
//  Test Project
//
//  Created by Admin on 07/06/2021.
//

import Foundation

struct FlickerPhoto: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
}
