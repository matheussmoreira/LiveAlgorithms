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
                                .zIndex(2)
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
            if vm.showTwoNodesAlert || vm.showDisconnectedGraphAlert {
                Rectangle()
                    .fill(Color.blackGray)
                    .blur(radius: 10)
                    .overlay {
                        VStack {
                            Text(vm.alertText)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button(action: {
                                withAnimation { vm.hideAlert() }
                            }) {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(.clear)
                                    .border(Color.white)
                                    .frame(width: 100, height: 50)
                                    .overlay {
                                        Text("Ok")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding()
                                    }
                            }
                        }
                    }
            }
            // MARK: End Alert
            
            VStack {
                AppTitleInline()
                    .padding(.top, 32)
                
                TopBar(text: vm.topBarText)
                    .frame(height: UIHelper.screenHeight * 64/1133)
                    .padding(.top, 32)
                    .opacity(vm.showTwoNodesAlert ? 0 : 1)
                
                // MARK: Graph space
                Spacer()
                
                // MARK: Bottom bar
                HStack {
                    // Previous step
                    if !vm.isSelectingAlgorithm || vm.isSettingEdgesWeights {
                        Button(action: {
                            withAnimation {
                                vm.previousStep()
                            }
                        }) {
                            Arrow(next: false)
                        }
                        .opacity(vm.previousStepButtonOpacity)
                        .disabled(vm.previousStepButtonIsDisabled)
                    }
                    
                    
                    // Options bar
                    if vm.isBuildingGraph {
                        BuildGraphOptionsBar(vm: vm)
                            .padding()
                    } else if vm.isSettingEdgesWeights {
                        AlgorithmNameBar(text: vm.selectedAlgorithm?.id ?? "")
                            .padding()
                    } else if !vm.isSelectingAlgorithm {
                        PickAlgorithmOptionsBar(vm: vm)
                            .padding()
                    } else {
                        AlgorithmsList(vm: vm)
                            .padding()
                    }
                    
                    // Next step
                    if !vm.isSelectingAlgorithm && !vm.isSettingEdgesWeights {
                        Button(action: {
                            withAnimation {
                                vm.nextStep()
                            }
                        }) {
                            Arrow(next: true)
                        }
                    }
                }
                .opacity(vm.showTwoNodesAlert
                         || vm.showDisconnectedGraphAlert ? 0 : 1)
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
