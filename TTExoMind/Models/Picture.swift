//
//  Picture.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import Foundation

struct Picture: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
