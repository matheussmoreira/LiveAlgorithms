//
//  CoverView.swift
//  
//
//  Created by Matheus S. Moreira on 08/04/23.
//

import SwiftUI

struct CoverView: View {
    private let graphHiddenNodes = Graph.generateHiddenForCover()
    private let graphUnhiddenNodes = Graph.generateUnhiddenForCover()
    
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
            
            ForEach(graphHiddenNodes.nodes) { node in
                NodeView(node: node, decreasedZIndex: false)
                    .position(node.position)
            }
            
            ForEach(0..<graphUnhiddenNodes.edges.count, id: \.self) { i in
                let nodeEdges = graphUnhiddenNodes.edges[i]
                ForEach(0..<nodeEdges.count, id: \.self) { j in
                    let edge = nodeEdges[j]
                    EdgeView(edge: edge)
                }
            }
            
            ForEach(graphUnhiddenNodes.nodes) { node in
                NodeView(node: node, decreasedZIndex: false)
                    .position(node.position)
            }
            
            Image("GreenCircle")
                .frame(width: UIHelper.greenCircleSize.width,
                       height: UIHelper.greenCircleSize.width)
                .position(x: UIHelper.greenCirclePosition.x,
                          y: UIHelper.greenCirclePosition.y)
        }
    }
}
