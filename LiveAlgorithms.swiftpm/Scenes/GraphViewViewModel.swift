//
//  File.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

enum GraphMakingStep: CaseIterable {
    case nodeSelection
    case edgeSelection
    case initialFinalNodesSelection
    case askForAlgorithmSelection
    case algorithmSelection
    case edgesWeigthsSelection
    case algorithmSelected
}

enum Algorithm: String {
    case dfs = "Depth-first search"
    case bfs = "Breadth-first search"
    case djikstra = "Djikstra's shortest path"
    case mst = "Prim's minimum spanning tree"
}

class GraphViewViewModel: ObservableObject {
    // MARK: Stored Properties
    
    @Published var graph = Graph.generate()
    @Published var step: GraphMakingStep = .nodeSelection
    @Published var selectedAlgorithm: Algorithm?
    
    // MARK: - Computed Properties
    
    var previousStepButtonOpacity: Double {
        step != .nodeSelection ? 1 : 0
    }
    
    var previousStepButtonIsDisabled: Bool {
        step == .nodeSelection
    }
    
    var topBarText: String {
        switch step {
            case .nodeSelection:
                return "Select the nodes you want to remove from the graph"
            case .edgeSelection:
                return "Connect the nodes by tapping two of them in sequence"
            case .initialFinalNodesSelection:
                return "Select the nodes where the algorithms will start and finish"
            case .askForAlgorithmSelection:
                if let selectedAlgorithm = selectedAlgorithm {
                    return selectedAlgorithm.rawValue
                }
                return "Now, pick an algorithm to see it running live!"
            case .edgesWeigthsSelection:
                return "Tap on the edges to select a random weight to them"
            case .algorithmSelected:
                return selectedAlgorithm?.rawValue
                ?? "Now, pick an algorithm to see it running live!"
            default:
                return "Placeholder"
        }
    }
    
    // MARK: - Methods

    func nextStep() {
        switch step {
            case .nodeSelection:
                step = .edgeSelection
            case .edgeSelection:
                step = .initialFinalNodesSelection
            case .initialFinalNodesSelection:
                step = .askForAlgorithmSelection
            case .askForAlgorithmSelection:
                step = .algorithmSelection
            default:
                break
        }
    }
    
    func previousStep() {
        switch step {
            case .nodeSelection:
                break
            case .edgeSelection:
                step = .nodeSelection
            case .initialFinalNodesSelection:
                step = .edgeSelection
            case .askForAlgorithmSelection:
                step = .initialFinalNodesSelection
            default:
                step = .askForAlgorithmSelection
        }
    }
}