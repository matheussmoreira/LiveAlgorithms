//
//  Colors.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

extension Color {
    static let blackGray = Color(color(named: "blackGray"))
    static let darkGray = Color(color(named: "darkGray"))
    static let lightGray = Color(color(named: "lightGray"))
    static let myGreen = Color(color(named: "myGreen"))
    static let myRed = Color(color(named: "myRed"))
    
    // MARK: - Unwrap UIColor
    
    /// Load unwrapped colors from the .xcassets file
    private static func color(named name: String ) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Cannot found \(name) color")
        }
        return color
    }
}
