//
//  FinalNode.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct FinalNode: View {
    var isVisited: Bool
    
    var body: some View {
        Rectangle()
            .fill(Color.myRed)
            .frame(width: .nodeSize, height: .nodeSize)
            .border(Color.white, width: 3)
            .blur(radius: isVisited ? 10 : 0)
    }
}
