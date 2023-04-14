//
//  EdgeView.swift
//  
//
//  Created by Matheus S. Moreira on 02/04/23.
//

import SwiftUI

struct EdgeView: View {
    @ObservedObject var edge: Edge

    var color: Color {
        edge.inTree ? .white : .darkGray
    }
    
    var body: some View {
        Path { path in
            path.move(to: edge.sourcePosition)
            path.addLine(to: edge.destPosition)
        }
        .stroke(lineWidth: 3)
        .foregroundColor(color)
    }
}
