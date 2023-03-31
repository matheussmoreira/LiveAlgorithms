//
//  InitialNode.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct InitialNode: View {
    var isVisited: Bool
    
    var body: some View {
        Circle()
            .fill(Color.myGreen)
            .frame(width: .nodeSize, height: .nodeSize)
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
            }
            .blur(radius: isVisited ? 10 : 0)
    }
}
