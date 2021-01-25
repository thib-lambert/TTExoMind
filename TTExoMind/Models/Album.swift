//
//  Album.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import Foundation

struct Album: Codable {
    let userId: Int
    let id: Int
    let title: String
    
    func createFolder() {
        let destination = DiskTools.Users.usersDirectory.appendingPathComponent("user_\(self.userId)/album_\(self.id)")
        if !FileManager.default.fileExists(atPath: destination.path) {
            DiskTools.createFolder("Users/user_\(self.userId)/album_\(self.id)")
        }
    }
}
