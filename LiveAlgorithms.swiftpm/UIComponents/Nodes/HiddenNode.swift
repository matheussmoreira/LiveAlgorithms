//
//  HiddenNode.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct HiddenNode: View {
    var body: some View {
        Circle()
            .fill(Color.lightGray)
            .frame(width: Graph.nodeSize, height: Graph.nodeSize)
            .blur(radius: 10)
    }
}
