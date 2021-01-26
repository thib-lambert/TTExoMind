//
//  Address.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 22/01/2021.
//

import Foundation

struct Address: Codable {

    struct Geo: Codable {
        let lat: String
        let lng: String
    }

    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}
