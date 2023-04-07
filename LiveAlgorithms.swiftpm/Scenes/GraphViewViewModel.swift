//
//  GraphViewViewModel.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

class GraphViewViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    // General
    private var graphStack: Stack<Graph>
    @Published var graph: Graph
    @Published var step: GraphMakingStep
    
    // Node selection
    @Published var graphInitialNode: Node?
    @Published var graphFinalNode: Node?
    @Published var edgeSourceNode: Node?
    @Published var edgeDestNode: Node?
    
    // Algorithm selection
    @Published var selectedAlgorithm: Algorithm?
    @Published var isShowingAlgorithmsList = false
    
    // Alerts
    @Published var showTwoNodesAlert = false
    @Published var showDisconnectedGraphAlert = false
    @Published var showNoInitialFinalNodesAlert = false
    @Published var showNoInitialNodeAlert = false
    
    // MARK: - Computed Properties
    
    // Navigation buttons
    var nextButtonOpacity: Double {
        switch step {
        case .nodeSelection, .edgeSelection:
            return 1
        case .edgesWeigthsSelection, .onlyInitialNodeSelection:
            return selectedAlgorithm == .djikstra ? 1 : 0
        default:
            return 0
        }
    }
    
    var previousButtonOpacity: Double {
        switch step {
            case .nodeSelection, .algorithmsList:
            return 0
        default:
            return 1
        }
    }
    
    var showPreviousButton: Bool {
        return !isShowingAlgorithmsList
    }

    var showNextButton: Bool {
        return !isShowingAlgorithmsList
    }
    
    // User interaction
    var isEditingNodesAndEdges: Bool {
        return step == .nodeSelection
        || step == .edgeSelection
        || step == .initialFinalNodesSelection
        || step == .onlyInitialNodeSelection
    }
    
    var isSettingEdgesWeights: Bool {
        return step == .edgesWeigthsSelection
    }
    
    var showAlert: Bool {
        return showTwoNodesAlert
        || showDisconnectedGraphAlert
        || showNoInitialFinalNodesAlert
        || showNoInitialNodeAlert
    }
    
    // MARK: - Texts
    
    // Could use a stack in place of switch
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
                
            case .askingForAlgorithmSelection:
                return selectedAlgorithm?.rawValue
                ?? "Now, pick an algorithm to see it running live!"
                
            case .initialFinalNodesSelection:
                return "Select the nodes where the algorithms will start and finish"
                
            case .edgesWeigthsSelection:
                return "Tap on the edges to select a random weight for them"
                
            case .onlyInitialNodeSelection:
                return "Select the node where the algorithm will start from"
                
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
        } else if showNoInitialNodeAlert {
            return "The graph must have an initial node set!"
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
        showNoInitialNodeAlert = false
    }

}


// MARK: - Options bar

extension GraphViewViewModel {
    
    // MARK: Clear
    
    func clearButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.retrieveAllNodes()
            case .edgeSelection:
                removeAllEdges()
            case .initialFinalNodesSelection, .onlyInitialNodeSelection:
                clearInitialAndFinalNodes()
            default: break
        }
    }
    
    private func clearInitialAndFinalNodes() {
        graphInitialNode?.place = .normal
        graphInitialNode = nil
        graphFinalNode?.place = .normal
        graphFinalNode = nil
    }
    
    // MARK: Random
    
    func randomButtonTapped() {
        switch step {
            case .nodeSelection:
                graph.randomizeNodeSelection()
            case .edgeSelection:
                randomizeEdgeSelection()
            case .onlyInitialNodeSelection:
                #warning("randomizeInitialNodeSelection()")
                break
            case .initialFinalNodesSelection:
                randomizeInitialFinalNodesSelection()
            default: break
        }
    }
    
    // MARK: Algorithms setup
    
    func selectAlgorithm(_ alg: Algorithm) {
        selectedAlgorithm = alg
        isShowingAlgorithmsList = false
        
        if selectedAlgorithm == .djikstra || selectedAlgorithm == .mst {
            clearInitialAndFinalNodes()
            setRandomWeightsForAllEdges()
            step = .edgesWeigthsSelection
        } else {
            eraseAllEdgesWeights()
            step = .initialFinalNodesSelection
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
            case .onlyInitialNodeSelection:
                handleInitialStatus(for: node)
            case .initialFinalNodesSelection:
                handleInitialFinalStatus(for: node)
            default:
                break
        }
    }
    
    // MARK: Navigation issues
    
    private func hasLessThanTwoNodes() -> Bool {
        let nodesNumber = graph.unhiddenNodes.count
        if nodesNumber < 2 {
            showTwoNodesAlert = true
            return true
        }
        return false
    }
    
    private func hasNoInitialFinalNodes() -> Bool {
        let noNodes = (graphInitialNode == nil || graphFinalNode == nil)
        if noNodes { showNoInitialFinalNodesAlert = true }
        return noNodes
    }
    
    private func hasNoInitialNode() -> Bool {
        let noInitialNode = (graphInitialNode == nil)
        if noInitialNode { showNoInitialNodeAlert = true }
        return noInitialNode
    }
    
    // MARK: Initial and final nodes
    
    private func handleInitialFinalStatus(for node: Node) {
        if graphInitialNode == nil {
            graphInitialNode = node
            node.toggleInitialStatus()
        } else if node.isInitial {
            graphInitialNode = nil
            node.toggleInitialStatus()
        } else if graphFinalNode == nil {
            graphFinalNode = node
            node.toggleFinalStatus()
        } else if node.isFinal {
            graphFinalNode = nil
            node.toggleFinalStatus()
        }
    }
    
    private func handleInitialStatus(for node: Node) {
        if graphInitialNode == nil {
            graphInitialNode = node
            node.toggleInitialStatus()
        } else if node.isInitial {
            graphInitialNode = nil
            node.toggleInitialStatus()
        } else {
            graphInitialNode?.toggleInitialStatus()
            graphInitialNode = node
            node.toggleInitialStatus()
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
        for nodeEdges in graph.edges {
            nodeEdges.forEach {$0.eraseWeight()}
        }
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
    
    // MARK: Clear and random
    
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
    
    // MARK: Navigation issues
    
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

    func nextButtonTapped() {
        switch step {
            case .nodeSelection:
                if hasLessThanTwoNodes() { return }
                graphStack.push(graph.copy()) // Nodes only
                step = .edgeSelection
                
            case .edgeSelection:
                if foundDisconnectedGraph() { return }
                graphStack.push(graph.copy()) // Nodes + edges
                step = .askingForAlgorithmSelection

            case .edgesWeigthsSelection:
                step = .onlyInitialNodeSelection // Djikstra
            
            case .onlyInitialNodeSelection:
                if hasNoInitialNode() { return }
                step = .askingForAlgorithmSelection // Djikstra
                
            default: break
        }
    }
    
    func previousButtonTapped() {
        switch step {
            case .edgeSelection:
                retrievePreviousGraph() // Nodes only
                graph.unvisitAllNodes()
                step = .nodeSelection
                
            case .askingForAlgorithmSelection:
                retrievePreviousGraph() // Nodes + edges + initial/final
                clearInitialAndFinalNodes()
                eraseAllEdgesWeights()
                step = .edgeSelection
                
            case .edgesWeigthsSelection:
                step = .askingForAlgorithmSelection // Djikstra, Prim
                
            case .onlyInitialNodeSelection:
                clearInitialAndFinalNodes()
                step = .edgesWeigthsSelection // Djikstra
                
            case .initialFinalNodesSelection:
                step = .askingForAlgorithmSelection // DFS, BFS
                
            default: break
        }
    }
    
    func showAlgorithmsList() {
        isShowingAlgorithmsList = true
    }
    
    func runButtonTapped() {
        switch selectedAlgorithm {
        case .djikstra:
            if hasNoInitialNode() { break }
                
        case .bfs, .dfs:
            if hasNoInitialFinalNodes() { break }
                
        default: break
        }
    }
}
