//
//  NormalNode.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct NormalNode: View {
    var isVisited: Bool
    
    var body: some View {
        if isVisited {
            Circle()
                .fill(Color.white)
                .frame(width: .nodeSize, height: .nodeSize)
                .blur(radius: 10)
        } else {
            Circle()
                .fill(Color.darkGray)
                .frame(width: .nodeSize, height: .nodeSize)
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                }
        }
    }
}
