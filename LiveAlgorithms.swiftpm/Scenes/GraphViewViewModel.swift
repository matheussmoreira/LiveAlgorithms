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
    @Published var step: GraphMakingStep = .nodeSelection
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
    }
    
    // MARK: - Edges
    
    func handleAttempToDrawEdge(from node: Node) {
        if step != .edgeSelection { return }
        if node.isHidden { return }
        
        if edgeSourceNode == nil {
            setEdgeSourceNode(node)
        } else {
            // Picking dest node
            do {
                let nodeContainsEdge = try edgeConnects(node)
                if !nodeContainsEdge { setEdgeDestNode(node) }
            } catch {
                // EdgeError: there is no source node
            }
        }
    }
    
    private func setEdgeSourceNode(_ node: Node) {
        edgeSourceNode = node
        edgeSourceNode?.type = .visited
    }
    
    private func setEdgeDestNode(_ node: Node) {
        if edgeSourceNode == node {
            edgeSourceNode?.type = .notVisited
            edgeSourceNode = nil
            return
        }
        
        do {
            edgeDestNode = node
            let edge = try Edge(from: edgeSourceNode!, to: edgeDestNode!)
            graph.addEdge(edge)
            clearEdgeInitialDestNodes()
        } catch {
            print("Error: attempt to draw invalid edge!")
        }
    }
    
    private func edgeConnects(_ destNode: Node) throws -> Bool {
        guard let edgeSourceNode = edgeSourceNode else {
            throw EdgeError.nilSourceNode
        }
        
        for nodeEdge in graph.edges[edgeSourceNode.id] {
            if nodeEdge.dest == destNode { return true }
        }
        
        return false
    }
    
    func clearEdgeInitialDestNodes() {
        edgeSourceNode?.type = .notVisited
        edgeSourceNode = nil
        edgeDestNode = nil
    }
    
    func removeEdge(_ edge: Edge) {
        let copy = graph.copy()
        copy.removeEdge(edge)
        graph = copy
    }
    
    func removeAllEdges() {
        let copy = graph.copy()
        copy.removeAllEdges()
        graph = copy
    }
    
    // MARK: - Options bar
    
    func clearAction() {
        switch step {
            case .nodeSelection:
                graph.retrieveAllNodes()
            case .edgeSelection:
                removeAllEdges()
            default: break
        }
    }
    
    // MARK: - Navigation
    
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
