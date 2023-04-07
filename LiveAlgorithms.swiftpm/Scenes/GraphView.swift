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
                        EdgeView(edge: edge)
                            .zIndex(-1)
                            .onTapGesture {
                                withAnimation {
                                    vm.handleEdgeTap(edge)
                                }
                            }
                    }
                }
                
                // Weights
                ForEach(0..<vm.graph.nodes.count, id: \.self) { i in
                    let nodeEdges = vm.graph.edges[i]
                    ForEach(0..<nodeEdges.count, id: \.self) { j in
                        let edge = nodeEdges[j]
                        if edge.weight != 0 {
                            WeightCard(number: edge.weight)
                                .position(x: edge.weightPosition.x,
                                           y: edge.weightPosition.y)
                                .zIndex(1)
                                .onTapGesture {
                                    withAnimation {
                                        vm.setRandomWeightOn(edge)
                                    }
                                }
                        }

                    }
                }
                
                // Nodes
                ForEach(vm.graph.nodes) { node in
                    NodeView(node: node)
                        .position(node.position)
                        .onTapGesture {
                            withAnimation {
                                vm.handleNodeTap(node)
                            }
                        }
                }
            }
            // MARK: End Graph
            
            // MARK: Alert
            if vm.showAlert {
                AlertView(vm: vm)
            }
            // MARK: End Alert
            
            VStack {
                if !vm.showAlert {
                    AppTitleInline()
                        .padding(.top, 32)
                }
                
                if !vm.showAlert {
                    TopBar(text: vm.topBarText)
                        .frame(height: UIHelper.screenHeight * 64/1133)
                        .padding(.top, 32)
                        .opacity(vm.showTwoNodesAlert ? 0 : 1)
                }
                
                // MARK: Graph space
                Spacer()
                
                // MARK: Bottom bar
                HStack {
                    // Previous step
                    if vm.showPreviousButton {
                        Button(action: {
                            withAnimation { vm.previousButtonTapped() }
                        }) {
                            Arrow(next: false)
                        }
                        .opacity(vm.previousButtonOpacity)
                    }
                    
                    // Options bar
                    if vm.isEditingNodesAndEdges {
                        ClearRandomButtonsBar(vm: vm)
                            .padding()
                    } else if vm.isSettingEdgesWeights {
                       AlgorithmNameBar(text: vm.selectedAlgorithm?.id ?? "")
                           .padding()
                    } else if !vm.isShowingAlgorithmsList {
                        SelectAlgorithmAndRunBar(vm: vm)
                            .padding()
                    } else {
                        AlgorithmsList(vm: vm)
                            .padding()
                    }
                    
                    // Next step
                    if vm.showNextButton {
                        Button(action: {
                            withAnimation { vm.nextButtonTapped() }
                        }) {
                            Arrow(next: true)
                        }
                        .opacity(vm.nextButtonOpacity)
                    }
                }
                .opacity(vm.showAlert ? 0 : 1)
                
                // MARK: End bottom bar

            } // VStack
        } // ZStack
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
