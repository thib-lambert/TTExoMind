//
//  Tools.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 25/01/2021.
//

import Foundation
import UIKit

class Tools {
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func storeImage(image: UIImage, key: String) {
        if let pngRepresentation = image.pngData() {
        
            let newKey = key.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "-")
            
            // URL destination
            let destination = self.documentsDirectory.appendingPathComponent(newKey + ".png")
            
            // Vérification de l'existance de l'image
            if imageIsAlreadySave(key: key) {
                do  {
                    try pngRepresentation.write(to: destination, options: .atomic)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func retrieveImage(key: String) -> UIImage? {
        let newKey = key.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "-")
        let source = self.documentsDirectory.appendingPathComponent(newKey + ".png")
        guard let fileData = FileManager.default.contents(atPath: source.path) else { return nil }
        return UIImage(data: fileData)
    }
    
    static func imageIsAlreadySave(key: String) -> Bool {
        let newKey = key.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "-")
        let source = self.documentsDirectory.appendingPathComponent(newKey + ".png")
        return FileManager.default.fileExists(atPath: source.path)
    }
}
