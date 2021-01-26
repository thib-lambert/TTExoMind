//
//  UIColor+Utils.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import UIKit

extension UIColor {
    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        let red = UInt8((hex >> 16) & 0xff)
        let green = UInt8((hex >> 8) & 0xff)
        let blue = UInt8(hex & 0xff)
        self.init(red: red, green: green, blue: blue)
    }

    struct App {
        static var grey = UIColor(hex: 0xdddddd)
        static var orange = UIColor(hex: 0xdb6400)
        static var gold = UIColor(hex: 0xffa62b)
    }
}
