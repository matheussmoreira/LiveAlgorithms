//
//  Colors.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

extension Color {
    static let darkGray = Color(color(named: "darkGray"))
    static let blackGray = Color(color(named: "blackGray"))
    
    // MARK: - Unwrap UIColor
    
    /// Load unwrapped colors from the .xcassets file
    private static func color(named name: String ) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Cannot found \(name) color")
        }
        return color
    }
}
