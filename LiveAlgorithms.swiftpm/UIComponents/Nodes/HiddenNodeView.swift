//
//  HiddenNodeView.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct HiddenNodeView: View {
    var body: some View {
        Circle()
            .fill(Color.lightGray)
            .frame(width: .nodeSize, height: .nodeSize)
            .blur(radius: 10)
    }
}
