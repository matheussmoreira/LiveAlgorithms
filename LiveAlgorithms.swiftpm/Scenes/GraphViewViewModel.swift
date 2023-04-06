//
//  File.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

class GraphViewViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    // Navigation
    private var graphStack: Stack<Graph>
    @Published var graph: Graph
    @Published var step: GraphMakingStep
    
    // Node selection
    @Published var initialNode: Node?
    @Published var finalNode: Node?
    @Published var edgeSourceNode: Node?
    @Published var edgeDestNode: Node?
    
    // Algorithm selection
    @Published var selectedAlgorithm: Algorithm?
    @Published var isSelectingAlgorithm = false
    
    // Alerts
    @Published var showTwoNodesAlert = false
    @Published var showDisconnectedGraphAlert = false
    @Published var showNoInitialFinalNodesAlert = false
    
    // MARK: - Computed Properties
    
    var previousStepButtonOpacity: Double {
        step != .nodeSelection ? 1 : 0
    }
    
    var previousStepButtonIsDisabled: Bool {
        step == .nodeSelection
    }
    
    var isBuildingGraph: Bool {
        return step == .nodeSelection
        || step == .edgeSelection
        || step == .initialFinalNodesSelection
    }
    
    var isSettingEdgesWeights: Bool {
        return step == .edgesWeigthsSelection
    }
    
    var showAlert: Bool {
        return showTwoNodesAlert
        || showDisconnectedGraphAlert
        || showNoInitialFinalNodesAlert
    }
    
    var showPreviousButton: Bool {
        return !isSelectingAlgorithm || isSettingEdgesWeights 
    }
    
    var showNextButton: Bool {
        return !isSelectingAlgorithm && !isSettingEdgesWeights
    }
    
    // MARK: - Texts
    
    // Could use a stack
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
            case .askingForAlgorithmSelection:
                if let selectedAlgorithm = selectedAlgorithm {
                    return selectedAlgorithm.rawValue
                }
                return "Now, pick an algorithm to see it running live!"
            case .edgesWeigthsSelection:
                return "Tap on the edges to select a random weight for them"
            case .algorithmSelected:
                return selectedAlgorithm?.rawValue
                ?? "Now, pick an algorithm to see it running live!"
            default:
                return "Placeholder"
        }
    }
    
    var alertText: String {
        if showTwoNodesAlert {
            return "The graph must have at least 2 nodes!"
        } else if showDisconnectedGraphAlert {
            return """
            The graph is disconnected!\n
            There must not be either a node or a subgraph disconnected from the whole.
            """
        } else if showNoInitialFinalNodesAlert {
            return "The graph must have both initial and final nodes set!"
        }
        return ""
    }
    
    // MARK: - Init
    
    init() {
        graph = Graph.generate()
        graphStack = Stack()
        step = .nodeSelection
    }
    
    // MARK: - Methods
    
    func hideAlert() {
        showTwoNodesAlert = false
        showDisconnectedGraphAlert = false
        showNoInitialFinalNodesAlert = false
    }

}


// MARK: - Options bar

extension GraphViewViewModel {
    
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
                randomizeEdgeSelection()
            case .initialFinalNodesSelection:
                randomizeInitialFinalNodesSelection()
            default: break
        }
    }
    
    func selectAlgorithm(_ alg: Algorithm) {
        selectedAlgorithm = alg
        isSelectingAlgorithm = false
        
        if selectedAlgorithm == .djikstra || selectedAlgorithm == .mst {
            setRandomWeightsForAllEdges()
            step = .edgesWeigthsSelection
        } else {
            eraseAllEdgesWeights()
            step = .askingForAlgorithmSelection
        }
    }
    
    private func setRandomWeightsForAllEdges() {
        for nodeEdges in graph.edges {
            for edge in nodeEdges {
                if edge.weight == 0 {
                    setRandomWeightOn(edge)
                }
            }
        }
    }
}

// MARK: - Nodes

extension GraphViewViewModel {
    
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
    
    private func hasLessThanTwoNodes() -> Bool {
        let nodesNumber = graph.unhiddenNodes.count
        if nodesNumber < 2 {
            showTwoNodesAlert = true
            return true
        }
        return false
    }
    
    private func hasNoInitialFinalNodes() -> Bool {
        let noNodes = (initialNode == nil || finalNode == nil)
        if noNodes { showNoInitialFinalNodesAlert = true }
        return noNodes
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
        guard let randomInitial = graph.unhiddenNodes.randomElement() else { return }
        let possibleFinalNodes = graph.unhiddenNodes.filter({$0 != randomInitial})
        guard let randomFinal = possibleFinalNodes.randomElement() else { return }
        
        clearInitialAndFinalNodes()
        handleInitialFinalStatus(for: randomInitial)
        handleInitialFinalStatus(for: randomFinal)
    }
    
}

// MARK: - Edges

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
    
    // MARK: Weights
    
    func setRandomWeightOn(_ edge: Edge) {
        let randomWeight = Int.random(in: 1...99)
        
        let copy = graph
        copy.setWeightOn(edge: edge, weight: randomWeight)
        graph = copy
    }
    
    private func eraseAllEdgesWeights() {
        let copy = graph.copy()
        for nodeEdges in copy.edges {
            for edge in nodeEdges {
                edge.weight = 0
            }
        }
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
    
    private func sourceNodeIsEqualTo(_ node: Node) -> Bool {
        if edgeSourceNode == node {
            edgeSourceNode?.type = .notVisited
            edgeSourceNode = nil
            return true
        }
        return false
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
    
    private func foundDisconnectedGraph() -> Bool {
        guard let randomNode = graph.unhiddenNodes.randomElement() else {
            return false
        }
        
        graph.dfs(startingFrom: randomNode)
        
        if !graph.visitedAllNodes {
            showDisconnectedGraphAlert = true
            graph.resetNodesVisitation()
            return true
        }
        graph.resetNodesVisitation()
        return false
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
                if hasLessThanTwoNodes() { return }
                graphStack.push(graph.copy()) // Nodes only
                step = .edgeSelection
                
            case .edgeSelection:
                if foundDisconnectedGraph() { return }
                graphStack.push(graph.copy()) // Nodes + edges
                step = .initialFinalNodesSelection
                
            case .initialFinalNodesSelection:
                if hasNoInitialFinalNodes() { return }
                graphStack.push(graph.copy()) // Nodes + edges + initial/final
                step = .askingForAlgorithmSelection
                
            case .askingForAlgorithmSelection:
                step = .algorithmsList
                
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
                graph.unvisitAllNodes()
                step = .nodeSelection
            case .initialFinalNodesSelection:
                retrievePreviousGraph() // Nodes + edges
                clearInitialAndFinalNodes()
                step = .edgeSelection
            case .askingForAlgorithmSelection:
                retrievePreviousGraph() // Nodes + edges + initial/final
                eraseAllEdgesWeights()
                step = .initialFinalNodesSelection
            default:
                step = .askingForAlgorithmSelection
        }
    }
}
