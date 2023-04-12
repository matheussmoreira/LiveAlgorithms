//
//  CoverView.swift
//  
//
//  Created by Matheus S. Moreira on 08/04/23.
//

import SwiftUI

struct CoverView: View {
    @StateObject private var graphUnhiddenNodes = Graph.generateUnhiddenForCover()
    private let graphHiddenNodes = Graph.generateHiddenForCover()
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image.appTitleRect
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.ignoresSafeArea()
            
            // Hidden nodes
            ForEach(graphHiddenNodes.nodes) { node in
                NodeView(node: node, decreasedZIndex: false)
                    .position(node.position)
            }
            
            // Edges
            ForEach(0..<graphUnhiddenNodes.edges.count, id: \.self) { i in
                let nodeEdges = graphUnhiddenNodes.edges[i]
                ForEach(0..<nodeEdges.count, id: \.self) { j in
                    let edge = nodeEdges[j]
                    EdgeView(edge: edge)
                }
            }
            
            // Unhidden nodes
            ForEach(graphUnhiddenNodes.nodes) { node in
                NodeView(node: node, decreasedZIndex: false)
                    .position(node.position)
            }
        }
        .onAppear {
            withAnimation {
                buildGraph()
            }
        }
    }
}

extension CoverView {
    func buildGraph() {
        var id = 0
        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            id += 1
            graphUnhiddenNodes.build(withNewNodeOfId: id)
            if id == 25 { timer.invalidate() }
        }
    }
}
