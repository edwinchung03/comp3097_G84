//
//  UIColor.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-03-11.
//

import UIKit

extension UIColor {
    func toHexString() -> String{
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = Int(r*255) << 16 | Int(g*255) << 8 | Int(b*255)
        
        return String(format: "#%06x", rgb)
    }
}
