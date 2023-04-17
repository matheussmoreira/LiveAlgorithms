//
//  GraphView.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct GraphView: View {
    @Binding var page: Page
    @Binding var showPopupAgain: Bool
    @StateObject private var vm = GraphViewViewModel()
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            // MARK: Graph
            ZStack {
                // Edges and weights
                ForEach(0..<vm.graph.nodes.count, id: \.self) { i in
                    let nodeEdges = vm.graph.edges[i].filter({$0.inTree})
                    
                    ForEach(0..<nodeEdges.count, id: \.self) { j in
                        let edge = nodeEdges[j]
                        
                        EdgeView(edge: edge)
                            .onTapGesture {
                                withAnimation {
                                    vm.handleEdgeTap(edge)
                                }
                            }
                        
                        if edge.weight != 0 {
                            let x = edge.weightPosition.x
                            let y = edge.weightPosition.y
                            
                            WeightCard(edge: edge)
                                .position(x: x, y: y)
                                .zIndex(1)
                                .onTapGesture {
                                    withAnimation {
                                        vm.setRandomWeightOn(edge)
                                    }
                                }
                        }
                    } // ForEach
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
            
            // MARK: Alerts and popup
            
            if showPopupAgain && vm.showGenericInstructionPopup {
                GenericInstructionView(vm: vm, showPopupAgain: $showPopupAgain)
            }
            
            if vm.showAlert {
                AlertView(vm: vm)
            }
            
            if vm.showAlgorithmExplanationBox {
                ExplanationBoxView(vm: vm, algorithm:
                                    vm.selectedAlgorithmForExplanation)
            }
            
            VStack {
                // MARK: Top part
                if !vm.showAlert {
                    AppTitleInline()
                        .padding(.top, 32)
                }
                
                if !vm.showAlert {
                    TopBar(text: vm.topBarText)
                        .frame(height: UIHelper.screenHeight * 64/1133)
                        .padding(.top, 32)
                        .opacity(vm.topBarOpacity)
                }
                
                // MARK: Graph space
                Spacer()
                
                // MARK: Bottom bar
                HStack {
                    // Previous step
                    if vm.showPreviousButton {
                        Button(action: {
                            withAnimation {
                                if vm.isChoosingNodes {
                                    page = .tutorialPage
                                } else {
                                    vm.previousButtonTapped()
                                }
                            }
                        }) {
                            Arrow(next: false)
                        }
                        .opacity(vm.previousButtonOpacity)
                    }
                    
                    // Options bar
                    if vm.isEditingNodesAndEdges {
                        ClearRandomBar(vm: vm)
                            .padding()
                            .opacity(vm.clearRandomBarOpacity)
                        
                    } else if vm.isSettingEdgesWeights {
                       AlgorithmNameBar(text: vm.selectedAlgorithm?.id ?? "").padding()
                        
                    } else if vm.isAboutToPickOrRunAlgorithm {
                        SelectAlgorithmAndRunBar(vm: vm).padding()
                        
                    } else if vm.algorithmIsLive {
                        StopPauseResumeBar(vm: vm).padding()
                        
                    } else {
                        AlgorithmsList(vm: vm)
                            .padding()
                            .opacity(vm.algorithmsListOpacity)
                    }
                    
                    // Next step
                    if vm.showNextButton {
                        Button(action: {
                            withAnimation {
                                if vm.isAboutToPickOrRunAlgorithm {
                                    page = .finalPage
                                } else {
                                    vm.nextButtonTapped()
                                }
                            }
                        }) {
                            Arrow(next: true)
                        }
                        .opacity(vm.nextButtonOpacity)
                    }
                }
                .opacity(vm.showAlert ? 0 : 1)

            } // VStack
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if showPopupAgain {
                    withAnimation {
                        vm.showGenericInstructionPopup = true
                    }
                }
            })
        }
        // ZStack
    }
}
