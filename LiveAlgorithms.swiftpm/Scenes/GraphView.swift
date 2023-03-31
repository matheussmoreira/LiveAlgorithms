//
//  GraphView.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct GraphView: View {
    @StateObject private var graph = Graph.generate()
//    @State private var nodeOpacity: Double = 1
//    @State private var delay: Double = 0.2
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            // MARK: Graph
            ZStack {
                #warning("Draw edges")
                
                // Nodes
                ForEach(graph.nodes) { node in
                    NodeView(node: node)
                        .position(node.position)
//                            .opacity(nodeOpacity)
                        .onTapGesture {
                            removeNode(node)
                        }
//                            .onAppear {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
//                                    nodeOpacity = 1
//                                    delay += 0.1
//                                })
//                            }
                }
            }
            // MARK: End Graph
            
            VStack {
                AppTitleInline()
                    .padding(.top, 32)
                
                #warning("Change text according to navigation")
                BlackBand(text: "Select the nodes you want to remove from the graph")
                    .frame(height: UIHelper.screenHeight * 64/1133)
                    .padding(.top, 32)
                
                Spacer()
                
                #warning("Code navigation and options")
                HStack {
                    #warning("Arrow previous")
                    NodeSelectionOptionsBar(graph: graph)
                        .padding()
                    Button(action: {}) {
                        Arrow(next: true)
                    }
                }

            } // VStack
        } // ZStack
    }
}

extension GraphView {
    private func removeNode(_ node: Node) {
        withAnimation {
            node.toggleHiddenStatus()
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
