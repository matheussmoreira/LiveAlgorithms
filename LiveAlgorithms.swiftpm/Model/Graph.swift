//
//  Graph.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Graph: ObservableObject, Copying {
    
    // MARK: - Type Properties
    
    static let maxNodesQuant = UIHelper.nodesPositions.count
    static let maxHiddenNodesQuantCover = UIHelper.coverHiddenNodesPositions.count
    static let nodeSize: CGFloat = 30
    
    // MARK: - Properties
    
    @Published var nodes: [Node]
    @Published var edges: [[Edge]]
    @Published var visitedFinalNodeId: Int?
    @Published var visitedNodesIds = [Int]()
    @Published var algorithmState: AlgorithmState = .notStarted
    
    var selectedAlgorithm: Algorithm?
    var timer: Timer?
    var finalNodeId: Int?
    var edgesInTree = [Int:Edge?]()
    
    // MARK: - Computed Properties
    
    var visitedAllNodes: Bool {
        return visitedNodesIds.count == unhiddenNodes.count
    }
    
    var unhiddenNodes: [Node] {
        return nodes.filter({!$0.isHidden})
    }
    
    // MARK: - Init
    
    init(nodes: [Node]) {
        self.nodes = nodes
        self.edges = [[Edge]]()
        
        for _ in nodes {
            edges.append([Edge]())
        }
    }
    
    init(nodes: [Node], edges: [[Edge]]) {
        self.nodes = nodes
        self.edges = edges
    }
    
    required convenience init(_ prototype: Graph) {
        self.init(nodes: prototype.nodes, edges: prototype.edges)
    }
    
    // MARK: - Timer
    
    func stopTimer() {
        timer?.invalidate()
        algorithmState = .notStarted
    }
    
    // MARK: - Nodes
    
    func addNode(_ node: Node) {
        nodes.append(node)
        edges.append([Edge]())
    }
    
    func retrieveAllNodes() {
        nodes.forEach { $0.setAsNotVisited() }
    }
    
    func randomizeNodeSelection() {
        nodes.forEach { $0.randomizeSelection() }
    }
    
    // MARK: Visitation
    
    func eraseVisitedNodesIdsArray() {
        visitedNodesIds = []
    }
    
    func unvisitAllNodes() {
        eraseVisitedNodesIdsArray()
        for node in unhiddenNodes where node.isVisited {
            node.setAsNotVisited()
        }
    }
    
    func removeEdgesFromTree() {
        for nodeEdges in edges {
            for edge in nodeEdges {
                if !edgesInTree.contains(where: {$0.value == edge}) {
                    edge.setAsOutOfTree()
                }
            }
        }
        unvisitAllNodes()
    }
    
    func resetTree() {
        for nodeEdges in edges {
            for edge in nodeEdges {
                edge.setAsInTree()
            }
        }
        edgesInTree = [:]
    }
    
}

// MARK: - Edges

extension Graph {
    
    // MARK: Create edges
    
    func addEdge(_ edge: Edge) {
        return addEdge(edge, on: &edges)
    }
    
    private func addEdge(_ edge: Edge, on graphEdges: inout [[Edge]]) {
        let rev = edge.reversed
        graphEdges[edge.source.id].append(edge)
        graphEdges[edge.dest.id].append(rev)
    }
    
    func getRandomEdges() -> [[Edge]] {
        let randomEdges = generateRandomTree()
        /*
        let nodes = unhiddenNodes

        for sourceNode in nodes {
            let destNodes = unhiddenNodes.filter {$0 != sourceNode}
            var destNodesQuant = 1 // Int.random(in: 0...destNodes.count)

            while (destNodesQuant > 0) {
                guard let destNode = destNodes.randomElement() else { break }
                if edgeConnects(sourceNode, to: destNode, on: randomEdges) { continue }

                let edge = Edge(from: sourceNode, to: destNode)
                addEdge(edge, on: &randomEdges)
                destNodesQuant -= 1
            }
        }
        */
        return randomEdges
    }
    
    private func generateRandomTree() -> [[Edge]] {
        var edgesMatrix = Self.createEmptyEdgesMatrix(quantity: nodes.count)
        var nodes = unhiddenNodes
        
        guard var sourceNode = nodes.randomElement() else { return edgesMatrix }
        nodes.removeAll(where: {$0.id == sourceNode.id})
        
        while !nodes.isEmpty {
            guard let destNode = nodes.randomElement() else { break }
            let edge = Edge(from: sourceNode, to: destNode)
            addEdge(edge, on: &edgesMatrix)
            nodes.removeAll(where: {$0.id == destNode.id})
            sourceNode = destNode
        }
        
        return edgesMatrix
    }
    
    static func createEmptyEdgesMatrix(quantity: Int) -> [[Edge]] {
        var newEdges = [[Edge]]()
        for _ in 0..<quantity {
            newEdges.append([Edge]())
        }
        return newEdges
    }
    
    // MARK: Checking for existing connections
    
    func edgeConnects(_ sourceNode: Node, to destNode: Node) -> Bool {
        return edgeConnects(sourceNode, to: destNode, on: edges)
    }
    
    private func edgeConnects(_ sourceNode: Node, to destNode: Node, on graphEdges: [[Edge]]) -> Bool {
        for sourceNodeEdge in graphEdges[sourceNode.id] {
            if sourceNodeEdge.dest == destNode { return true }
        }
        return false
    }
    
    // MARK: Weights
    
    func setWeightOn(edge: Edge, weight: Int) {
        let sourceNode = nodes[edge.source.id]
        let destNode = nodes[edge.dest.id]
        
        _ = edges[sourceNode.id].map {
            if $0 == edge {
                edge.weight = weight
                return
            }
        }
        _ = edges[destNode.id].map {
            if $0 == edge {
                edge.weight = weight
                return
            }
        }

    }
    
    // MARK: Remove edges
    
    func removeEdge(_ edge: Edge) {
        let sourceNode = nodes[edge.source.id]
        let destNode = nodes[edge.dest.id]
        edges[sourceNode.id].removeAll(where: { $0 == edge })
        edges[destNode.id].removeAll(where: { $0 == edge.reversed })
    }
    
    func removeAllEdges() {
        for nodeEdges in edges {
            for edge in nodeEdges {
                removeEdge(edge)
            }
        }
    }
    
    // MARK: Remove reversed in array
    
    static func removeReversedIn(_ edgesArray: inout [Edge]) {
        var toRemove = [Edge]()
        
        for ed in 0..<edgesArray.count-1 {
            for next in ed+1..<edgesArray.count {
                if edgesArray[ed] ~= edgesArray[next] {
                    toRemove.append(edgesArray[next] )
                }
            }
        }
        
        for ed in toRemove {
            edgesArray.removeAll(where: { $0 == ed })
        }
    }
    
    // MARK: Cover graph
    
    func build(withNewNodeOfId id: Int) {
        if !(1...25).contains(id) { return }
        
        let positions = UIHelper.coverUnhiddenNodesPositions
        var destNodeId = 0
        
        if (1...9).contains(id) || (11...13).contains(id) || id == 15
            || (17...19).contains(id) || (21...23).contains(id) || id == 25 {
            // Connecting to the previous node
            destNodeId = id-1
        } else {
            // Connecting to specific node
            switch id {
                case 10, 16: destNodeId = 3
                case 14: destNodeId = 10
                case 20: destNodeId = 18
                case 24: destNodeId = 22
                default: break
            }
        }
        
        let node = Node(id: id, position: positions[id])
        if id == 25 { node.toggleFinalStatus() }
        addNode(node)
        let edge = Edge(from: nodes[id], to: nodes[destNodeId])
        addEdge(edge)
    }
}

// MARK: - Generate graph

extension Graph {
    static func generate() -> Graph {
        var nodes = [Node]()
        for i in 0..<maxNodesQuant {
            let point = UIHelper.nodesPositions[i]
            let node = Node(id: i, position: point)
            nodes.append(node)
        }
        return Graph(nodes: nodes)
    }
    
    static func generateHiddenForCover() -> Graph {
        var nodes = [Node]()
        for i in 0..<maxHiddenNodesQuantCover {
            let point = UIHelper.coverHiddenNodesPositions[i]
            let node = Node(id: i, position: point)
            node.type = .hidden
            nodes.append(node)
        }
        return Graph(nodes: nodes)
    }
    
    static func generateUnhiddenForCover() -> Graph {
        var edges = [[Edge]]()
        for _ in 0...25 {edges.append([Edge]())}
        
        let positions = UIHelper.coverUnhiddenNodesPositions
        let graph = Graph(nodes: [Node](), edges: edges)
        let node = Node(id: 0, position: positions[0])
        
        node.toggleInitialStatus()
        graph.addNode(node)
        
        return graph
    }
    
    static func randomPlacedNodes() -> Graph {
        var nodes = [Node]()
        
        for i in 0..<maxNodesQuant {
            // #warning("Tratar nós sobrepostos")
            let randomX = CGFloat.random(in: getHRange())
            let randomY = CGFloat.random(in: getHRange())
            let randomPoint = CGPoint(x: randomX, y: randomY)
            let node = Node(id: i, position: randomPoint)
            nodes.append(node)
            
            func getHRange() -> ClosedRange<CGFloat> {
                let lowerBound = Self.nodeSize*2
                let higherBound = UIHelper.screenWidth - Self.nodeSize*2
                return lowerBound...higherBound
            }
            
            func getVRange() -> ClosedRange<CGFloat> {
                let lowerBound = UIHelper.screenHeight * 0.278
                let higherBound = UIHelper.screenWidth * 0.823
                return lowerBound...higherBound
            }
        }
        
        return Graph(nodes: nodes)
    }
}
