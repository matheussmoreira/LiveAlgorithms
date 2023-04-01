//
//  File.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

class GraphViewViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    private var graphStack: Stack<Graph>
    
    @Published var graph: Graph
    @Published var step: GraphMakingStep
    @Published var selectedAlgorithm: Algorithm?
    @Published var edgeSourceNode: Node?
    @Published var edgeDestNode: Node?
    
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
                return
                  """
                Connect the nodes by tapping two of them in sequence
                Tap on an edge to remove it
                """
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
    
    // MARK: - Init
    
    init() {
        graph = Graph.generate()
        graphStack = Stack()
        step = .nodeSelection
    }
    
    // MARK: - Options bar
    
    func clearButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.retrieveAllNodes()
            case .edgeSelection:
                removeAllEdges()
            default: break
        }
    }
    
    func randomButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.randomizeNodeSelection()
            case .edgeSelection:
                randomizeEdgeSelection()
            default: break
        }
    }
    
}

// MARK: - Edges

extension GraphViewViewModel {
    
    // MARK: Tapping on the nodes
    
    func attemptToConnect(_ node: Node) {
        if step != .edgeSelection { return }
        if node.isHidden { return }
        
        if edgeSourceNode == nil {
            edgeSourceNode = node
            edgeSourceNode?.type = .visited
        } else {
            do {
                // Picking dest node
                let nodeContainsEdge = try edgeConnects(node)
                if !nodeContainsEdge { connectSourceNodeTo(node) }
            } catch {
                // EdgeError: there is no source node
            }
        }
    }
    
    private func edgeConnects(_ destNode: Node) throws -> Bool {
        guard let edgeSourceNode = edgeSourceNode else {
            throw EdgeError.nilSourceNode
        }
        
        return graph.edgeConnects(sourceNode: edgeSourceNode, destNode: destNode)
    }
    
    private func connectSourceNodeTo(_ node: Node) {
        // Does not connect to the same node
        if edgeSourceNode == node {
            edgeSourceNode?.type = .notVisited
            edgeSourceNode = nil
            return
        }
        
        do {
            // Create edge
            edgeDestNode = node
            let edge = try Edge(from: edgeSourceNode!, to: edgeDestNode!)
            graph.addEdge(edge)
            
            // Clear selections
            edgeSourceNode?.type = .notVisited
            edgeSourceNode = nil
            edgeDestNode = nil
        } catch {
            // EdgeError: attempt to draw invalid edge!
        }
    }
    
    // MARK: Tapping on an edge
    
    func removeEdge(_ edge: Edge) {
        let copy = graph.copy()
        copy.removeEdge(edge)
        graph = copy
    }
    
    // MARK: Options bar handling
    
    private func removeAllEdges() {
        let copy = graph.copy()
        copy.removeAllEdges()
        graph = copy
    }
    
    private func randomizeEdgeSelection() {
        let copy = graph.copy()
        copy.edges = copy.getRandomEdges()
        graph = copy
    }
}

// MARK: - Navigation

extension GraphViewViewModel {
    
    private func retrievePreviousGraph() {
        if let poppedGraph = graphStack.pop() {
            graph = poppedGraph.copy()
        }
    }

    func nextStep() {
        switch step {
            case .nodeSelection:
                graphStack.push(graph.copy()) // Nodes only
                step = .edgeSelection
            case .edgeSelection:
                graphStack.push(graph.copy()) // Nodes + edges
                step = .initialFinalNodesSelection
            case .initialFinalNodesSelection:
                graphStack.push(graph.copy()) // Nodes + edges + initial/final
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
                retrievePreviousGraph() // Nodes only
                step = .nodeSelection
            case .initialFinalNodesSelection:
                retrievePreviousGraph() // Nodes + edges
                step = .edgeSelection
            case .askForAlgorithmSelection:
                retrievePreviousGraph() // Nodes + edges + initial/final
                step = .initialFinalNodesSelection
            default:
                step = .askForAlgorithmSelection
        }
    }
}
