//
//  User.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 22/01/2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
