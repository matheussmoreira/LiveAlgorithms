//
//  File.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

class GraphViewViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private var graphStack: Stack<Graph>
    
    @Published var graph: Graph
    @Published var step: GraphMakingStep
    @Published var selectedAlgorithm: Algorithm?
    @Published var initialNode: Node?
    @Published var finalNode: Node?
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
    
    // MARK: - Nodes
    
    func handleNodeTap(_ node: Node) {
        switch step {
            case .nodeSelection:
                node.toggleHiddenStatus()
            case .edgeSelection:
                attemptToConnect(node)
            case .initialFinalNodesSelection:
                handleInitialFinalStatus(for: node)
            default:
                break
        }
    }
    
    private func handleInitialFinalStatus(for node: Node) {
        if initialNode == nil {
            initialNode = node
            node.toggleInitialStatus()
        } else if node.isInitial {
            initialNode = nil
            node.toggleInitialStatus()
        } else if finalNode == nil {
            finalNode = node
            node.toggleFinalStatus()
        } else if node.isFinal {
            finalNode = nil
            node.toggleFinalStatus()
        }
    }
    
    private func randomizeInitialFinalNodesSelection() {
        let possibleInitialNodes = graph.nodes.filter({!$0.isHidden})
        let possibleFinalNodes = graph.nodes.filter({!$0.isHidden && !$0.isInitial})
        
        guard let randomInitial = possibleInitialNodes.randomElement(),
                let randomFinal = possibleFinalNodes.randomElement() else {
            return
        }
        
        clearInitialAndFinalNodes()
        handleInitialFinalStatus(for: randomInitial)
        handleInitialFinalStatus(for: randomFinal)
    }
    
    // MARK: - Options bar
    
    func clearButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.retrieveAllNodes()
            case .edgeSelection:
                removeAllEdges()
            case .initialFinalNodesSelection:
                clearInitialAndFinalNodes()
            default: break
        }
    }
    
    private func clearInitialAndFinalNodes() {
        initialNode?.place = .normal
        initialNode = nil
        finalNode?.place = .normal
        finalNode = nil
    }
    
    func randomButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.randomizeNodeSelection()
            case .edgeSelection:
                #warning("Adição de novas edges (aka grafo) tá esquisita")
                randomizeEdgeSelection()
            case .initialFinalNodesSelection:
                randomizeInitialFinalNodesSelection()
            default: break
        }
    }
    
}

// MARK: - Edge selection

extension GraphViewViewModel {
    
    // MARK: Tapping on an edge
    
    func handleEdgeTap(_ edge: Edge) {
        if edgeSourceNode != nil { return }
        if step != .edgeSelection { return }
        removeEdge(edge)
    }
    
    private func removeEdge(_ edge: Edge) {
        let copy = graph.copy()
        copy.removeEdge(edge)
        graph = copy
    }
    
    // MARK: Tapping on a node
    
    private func attemptToConnect(_ node: Node) {
        if step != .edgeSelection { return }
        if node.isHidden { return }
        
        if edgeSourceNode == nil {
            // Picking source node
            edgeSourceNode = node
            edgeSourceNode?.type = .visited
        } else {
            do {
                // Picking dest node
                let sameNode = sourceNodeIsEqualTo(node)
                if sameNode { return }
                
                let alreadyConnected = try edgeConnectsSourceNode(to: node)
                if alreadyConnected { return }
                
                connectSourceNodeTo(node)
            } catch {
                // EdgeError: there is no source node
            }
        }
    }
    
    private func edgeConnectsSourceNode(to destNode: Node) throws -> Bool {
        guard let edgeSourceNode = edgeSourceNode else {
            throw EdgeError.nilSourceNode
        }
        
        return graph.edgeConnects(edgeSourceNode, to: destNode)
    }
    
    private func sourceNodeIsEqualTo(_ node: Node) -> Bool {
        if edgeSourceNode == node {
            edgeSourceNode?.type = .notVisited
            edgeSourceNode = nil
            return true
        }
        return false
    }
    
    private func connectSourceNodeTo(_ node: Node) {
        // Create edge
        edgeDestNode = node
        let edge = Edge(from: edgeSourceNode!, to: edgeDestNode!)
        graph.addEdge(edge)
        
        // Clear selections
        edgeSourceNode?.type = .notVisited
        edgeSourceNode = nil
        edgeDestNode = nil
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
                #warning("Proibir menos de dois nós")
                graphStack.push(graph.copy()) // Nodes only
                step = .edgeSelection
            case .edgeSelection:
                #warning("Proibir grafo desconexo")
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
                clearInitialAndFinalNodes()
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
