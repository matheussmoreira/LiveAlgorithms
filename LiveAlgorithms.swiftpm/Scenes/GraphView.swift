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
                #warning("Draw edges")
                
                // Nodes
                ForEach(vm.graph.nodes) { node in
                    NodeView(node: node)
                        .position(node.position)
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
                    NodeSelectionOptionsBar(graph: vm.graph)
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
