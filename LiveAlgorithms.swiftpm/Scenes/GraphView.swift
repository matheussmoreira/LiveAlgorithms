//
//  GraphView.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct GraphView: View {
    @State private var graph = Graph.empty()
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack {
                AppTitleInline()
                    .padding(.top, 32)
                
                #warning("Change text according to navigation")
                BlackBand(text: "Select the nodes you want to remove from the graph")
                    .frame(height: 64)
                    .padding(.top, 32)
                
                // MARK: Graph
                ZStack {
                    #warning("Edges")
                    
                    // Nodes
                    GeometryReader { geometry in
                        let newGraph = Graph.graph(inBounds: geometry.size)
                        
                        ForEach(newGraph.nodes) { node in
                            NodeView(node: node)
                                .position(node.position)
                        }
                        .onAppear {
                            graph = newGraph
                        }
                    }
                }
                // MARK: End Graph
                
                #warning("Navigation")
                
            } // VStack
        } // ZStack
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
