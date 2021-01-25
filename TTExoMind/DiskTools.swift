//
//  DiskTools.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 25/01/2021.
//

import Foundation
import UIKit

class DiskTools {
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func createFolder(_ folder: String) {
        let directory = DiskTools.documentsDirectory.appendingPathComponent(folder)
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(#function) " + error.localizedDescription);
            }
        }
    }
    
    struct Users {
        
        static let usersDirectory = DiskTools.documentsDirectory.appendingPathComponent("Users")
        
        static func store(users: [User]) {
            // URL destination
            let destination = self.usersDirectory.appendingPathComponent("users.json")
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(users)
                try data.write(to: destination, options: [])
            } catch {
                print("\(#function) " + error.localizedDescription)
            }
        }
        
        static func retrieve() -> [User] {
            var result: [User] = []
            
            do {
                let jsonFile = self.usersDirectory.appendingPathComponent("users.json")
                let jsonData = try Data(contentsOf: jsonFile)
                result = try JSONDecoder().decode([User].self, from: jsonData)
                
                return result
            } catch {
                print("\(#function) " + error.localizedDescription)
                return result
            }
        }
        
        static var usersAreStored: Bool {
            let url = self.usersDirectory.appendingPathComponent("users.json")
            return FileManager.default.fileExists(atPath: url.path)
        }
    }
    
    struct Albums {
        static func store(albums: [Album], for user: User) {
            // URL destination
            let destination = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(user.id)/albums.json")
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(albums)
                try data.write(to: destination, options: [])
            } catch {
                print("\(#function) " + error.localizedDescription)
            }
        }
        
        static func retrieve(for user: User) -> [Album] {
            var result: [Album] = []
            
            do {
                let jsonFile = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(user.id)/albums.json")
                let jsonData = try Data(contentsOf: jsonFile)
                result = try JSONDecoder().decode([Album].self, from: jsonData)
                
                return result
            } catch {
                print("\(#function) " + error.localizedDescription)
                return result
            }
        }
        
        static func albumsAreStored(user: User) -> Bool {
            let url = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(user.id)/albums.json")
            return FileManager.default.fileExists(atPath: url.path)
        }
    }
    
    struct Pictures {
        static func store(pictures: [Picture], for album: Album) {
            // URL destination
            let destination = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(album.userId)/album_\(album.id)/pictures.json")
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(pictures)
                try data.write(to: destination, options: [])
            } catch {
                print("\(#function) " + error.localizedDescription)
            }
        }
        
        static func save(_ image: UIImage?, picture: Picture, forUserId userId: Int) {
            let key = picture.thumbnailUrl.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_")
            
            let destination = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(userId)/album_\(picture.albumId)/\(key).png")
            
            if let image = image, let pngRepresentation = image.pngData() {
                // Vérification de l'existence de l'image
                if !DiskTools.Pictures.pictureIsStored(picture: picture, forUserId: userId) {
                    do  {
                        try pngRepresentation.write(to: destination, options: .atomic)
                    } catch {
                        print("\(#function) " + error.localizedDescription)
                    }
                }
            }
        }
        
        static func retrieve(album: Album) -> [Picture] {
            var result: [Picture] = []
            
            do {
                let jsonFile = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(album.userId)/album_\(album.id)/pictures.json")
                let jsonData = try Data(contentsOf: jsonFile)
                result = try JSONDecoder().decode([Picture].self, from: jsonData)
                
                return result
            } catch {
                print("\(#function) " + error.localizedDescription)
                return result
            }
        }
        
        static func retrieve(picture: Picture, forUserId userId: Int) -> UIImage? {
            let key = picture.thumbnailUrl.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_")
            let source = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(userId)/album_\(picture.albumId)/\(key).png")
            guard let fileData = FileManager.default.contents(atPath: source.path) else { return nil }
            return UIImage(data: fileData)
        }
        
        static func picturesAreStored(album: Album) -> Bool {
            let source = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(album.userId)/album_\(album.id)/pictures.json")
            return FileManager.default.fileExists(atPath: source.path)
        }
        
        static func pictureIsStored(picture: Picture, forUserId userId: Int) -> Bool {
            let key = picture.thumbnailUrl.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_")
            let source = DiskTools.documentsDirectory.appendingPathComponent("Users/user_\(userId)/album_\(picture.albumId)/\(key).png")
            return FileManager.default.fileExists(atPath: source.path)
        }
    }
}
