//
//  InitialView.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct InitialView: View {
    let graph = Graph.graph()
    
    var body: some View {
        ZStack {
            Color.darkGray.ignoresSafeArea()
            
            AppTitleInline()
                .padding(.horizontal)
            
            ForEach(graph.nodes) { node in
                NodeView(node: node)
                    .position(x: node.position.x, y: node.position.y)
            }
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
