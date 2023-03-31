//
//  UIHelper.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct UIHelper {
    // Screen
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    // Graph
    static let graphX = screenWidth * 0.05
    static let graphWidth = screenWidth * 0.9
    static let graphHRange = graphX...graphX+graphWidth
    
    static let graphY = screenHeight * 0.25
    static let graphHeight = screenHeight * 0.55
    static let graphVRange = graphY...graphY+graphHeight
}
