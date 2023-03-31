//
//  GraphView.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct GraphView: View {
    @StateObject private var vm = GraphViewViewModel()
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            // MARK: Graph
            ZStack {
                // Edges
                ForEach(0..<vm.graph.nodes.count, id: \.self) { i in
                    let nodeEdges = vm.graph.edges[i]
                    ForEach(0..<nodeEdges.count, id: \.self) { j in
                        let edge = nodeEdges[j]
                        Path { path in
                            path.move(to: edge.sourcePosition)
                            path.addLine(to: edge.destPosition)
                        }
                        .strokedPath(StrokeStyle(lineWidth: 3))
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                #warning("Não funciona!")
                                vm.graph.removeEdge(edge)
                            }
                        }
                    }
                }
                
                // Nodes
                ForEach(vm.graph.nodes) { node in
                    NodeView(node: node)
                        .position(node.position)
                        .zIndex(node.isHidden ? -1 : 0)
                        .onTapGesture {
                            withAnimation {
                                handleNodeTap(node)
                            }
                        }
                }
            }
            // MARK: End Graph
            
            VStack {
                AppTitleInline()
                    .padding(.top, 32)
                
                TopBar(text: vm.topBarText)
                    .frame(height: UIHelper.screenHeight * 64/1133)
                    .padding(.top, 32)
                
                // Graph space
                Spacer()
                
                // MARK: Bottom bar
                HStack {
                    // Previous step
                    #warning("Tratar edgeSelection")
                    Button(action: {
                        withAnimation {
                            vm.previousStep()
                        }
                    }) {
                        Arrow(next: false)
                    }
                    .opacity(vm.previousStepButtonOpacity)
                    .disabled(vm.previousStepButtonIsDisabled)
                    
                    // Options bar
                    NodeSelectionOptionsBar(graph: vm.graph, vm: vm)
                        .padding()
                    
                    // Next step
                    Button(action: {
                        withAnimation {
                            vm.nextStep()
                        }
                    }) {
                        Arrow(next: true)
                    }
                }
                // MARK: End bottom bar

            } // VStack
        } // ZStack
    }
}

extension GraphView {
    func handleNodeTap(_ node: Node) {
        switch vm.step {
            case .nodeSelection:
                node.toggleHiddenStatus()
            case .edgeSelection:
                vm.handleAttempToDrawEdge(from: node)
            default:
                break
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
