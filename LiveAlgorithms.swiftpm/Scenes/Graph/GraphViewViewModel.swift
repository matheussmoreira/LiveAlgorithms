//
//  GraphViewViewModel.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation
import Combine

class GraphViewViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    // General
    private var graphStack: Stack<Graph>
    @Published var graph: Graph
    @Published var step: Step
    
    // Node selection
    @Published var graphInitialNode: Node?
    @Published var graphFinalNode: Node?
    @Published var edgeSourceNode: Node?
    @Published var edgeDestNode: Node?
    
    // Algorithm selection
    @Published var selectedAlgorithm: Algorithm?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Alerts
    @Published var showTwoNodesAlert = false
    @Published var showDisconnectedGraphAlert = false
    @Published var showNoInitialFinalNodesAlert = false
    @Published var showNoInitialNodeAlert = false
    
    // MARK: - Computed Properties
    
    // Navigation buttons
    var nextButtonOpacity: Double {
        switch step {
        case .nodeSelection,
                .edgeSelection,
                .edgesWeigthsSelection,
                .onlyInitialNodeSelection,
                .initialFinalNodesSelection,
                .askingForAlgorithmSelection:
            return 1
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
                && !algorithmIsLive
    }

    var showNextButton: Bool {
        return !isShowingAlgorithmsList
                && !algorithmIsLive
    }
    
    // User interaction
    var isEditingNodesAndEdges: Bool {
        return step == .nodeSelection
        || step == .edgeSelection
        || step == .initialFinalNodesSelection
        || step == .onlyInitialNodeSelection
    }
    
    var isChoosingInitialFinalNodes: Bool {
        return step == .initialFinalNodesSelection
    }
    
    var isSettingEdgesWeights: Bool {
        return step == .edgesWeigthsSelection
    }
    
    var isAboutToPickOrRunAlgorithm: Bool {
        return step == .askingForAlgorithmSelection
        
    }
    
    var isShowingAlgorithmsList: Bool {
        return step == .algorithmsList
    }
    
    var algorithmIsLive: Bool {
        return step == .liveAlgorithm
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
        return UIHelper.getTopBarText(for: step, algorithm: selectedAlgorithm)
    }
    
    var alertText: String {
        if showTwoNodesAlert {
            return .mustHave2NodesAlert
            
        } else if showDisconnectedGraphAlert {
            return .disconnectedGraphAlert
            
        } else if showNoInitialFinalNodesAlert {
            return .noInitialFinalNodesAlert
            
        } else if showNoInitialNodeAlert {
            return .noInitialNodeAlert
            
        }
        return "Placeholder"
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
                clearInitialFinalNodes()
            default: break
        }
    }
    
    private func clearInitialFinalNodes() {
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
                randomizeInitialNodeSelection()
            case .initialFinalNodesSelection:
                randomizeInitialFinalNodesSelection()
            default: break
        }
    }
    
    // MARK: Algorithms setup
    
    func selectAlgorithm(_ alg: Algorithm) {
        selectedAlgorithm = alg
        clearInitialFinalNodes()
        eraseAllEdgesWeights()
        graph.resetTree()
        
        if selectedAlgorithm == .djikstra || selectedAlgorithm == .prim {
            setRandomWeightsForAllEdges()
            step = .edgesWeigthsSelection
        } else {
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
        
        clearInitialFinalNodes()
        handleInitialFinalStatus(for: randomInitial)
        handleInitialFinalStatus(for: randomFinal)
    }
    
    private func randomizeInitialNodeSelection() {
        guard let randomInitial = graph.unhiddenNodes.randomElement() else { return }
        clearInitialFinalNodes()
        handleInitialStatus(for: randomInitial)
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
        graph.setWeightOn(edge: edge, weight: randomWeight)
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
            graph.eraseVisitedNodesIdsArray()
            return true
        }
        graph.eraseVisitedNodesIdsArray()
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
                graphStack.push(graph.copy())
                step = .edgeSelection
                
            case .edgeSelection:
                if foundDisconnectedGraph() { return }
                graphStack.push(graph.copy())
                step = .askingForAlgorithmSelection

            case .edgesWeigthsSelection:
                step = .onlyInitialNodeSelection
            
            case .onlyInitialNodeSelection:
                if hasNoInitialNode() { return }
                step = .askingForAlgorithmSelection
                
            case .initialFinalNodesSelection:
                if hasNoInitialFinalNodes() { return }
                step = .askingForAlgorithmSelection
                
            default: break
        }
    }
    
    func previousButtonTapped() {
        switch step {
            case .edgeSelection:
                retrievePreviousGraph()
                graph.unvisitAllNodes()
                step = .nodeSelection
                
            case .askingForAlgorithmSelection:
                retrievePreviousGraph()
                selectedAlgorithm = nil
                clearInitialFinalNodes()
                eraseAllEdgesWeights()
                graph.unvisitAllNodes()
                graph.resetTree()
                step = .edgeSelection
                
            case .onlyInitialNodeSelection:
                clearInitialFinalNodes()
                step = .edgesWeigthsSelection
            
            case .initialFinalNodesSelection:
                selectedAlgorithm = nil
                clearInitialFinalNodes()
                step = .askingForAlgorithmSelection
                
            case .edgesWeigthsSelection:
                selectedAlgorithm = nil
                eraseAllEdgesWeights()
                step = .askingForAlgorithmSelection
                
            default: break
        }
    }
    
    func showAlgorithmsList() {
        eraseGraph()
        step = .algorithmsList
    }
    
    func runAlgorithm() {
        if selectedAlgorithm == nil { return }
        
        switch selectedAlgorithm {
        case .dfs:
            if hasNoInitialFinalNodes() { break }
            graph.unvisitAllNodes()
            graph.resetTree()
            step = .liveAlgorithm
            graph.runDFS(startingFrom: graphInitialNode!)
            observeAlgorithmFinishedStatus()
                
        case .bfs:
            if hasNoInitialFinalNodes() { break }
            graph.unvisitAllNodes()
            graph.resetTree()
            step = .liveAlgorithm
            graph.runBFS(startingFrom: graphInitialNode!)
            observeAlgorithmFinishedStatus()
            
        case .djikstra:
            if hasNoInitialNode() { break }
            graph.unvisitAllNodes()
            graph.resetTree()
            step = .liveAlgorithm
            graph.runDjikstra(startingFrom: graphInitialNode!)
            observeAlgorithmFinishedStatus()
                
        default: // Prim
            if hasNoInitialNode() { break }
            graph.unvisitAllNodes()
            graph.resetTree()
            step = .liveAlgorithm
            graph.runPrim(startingFrom: graphInitialNode!)
            observeAlgorithmFinishedStatus()
        }
    }
    
    func eraseGraph() {
        graph.unvisitAllNodes()
        clearInitialFinalNodes()
    }
    
    private func observeAlgorithmFinishedStatus() {
        graph.$algorithmState.sink { state in
            if state == .notStarted {
                self.step = .askingForAlgorithmSelection
            }
        }.store(in: &cancellables)
    }
    
    func pauseResumeAlgorithm() {
        graph.algorithmState = .paused
    }
    
    func stopAlgorithm() {
        graph.stopTimer()
        graph.unvisitAllNodes()
        step = .askingForAlgorithmSelection
    }
}
