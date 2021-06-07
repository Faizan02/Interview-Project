//
//  FlickerResultsPage.swift
//  Test Project
//
//  Created by Admin on 07/06/2021.
//

import Foundation
struct FlickerResultsPage: Codable {
    let page: Int
    let pages: Int
    let photo: [FlickerPhoto]
}
