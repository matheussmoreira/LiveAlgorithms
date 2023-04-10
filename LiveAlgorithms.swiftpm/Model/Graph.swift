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
    @Published var algorithmIsRunning = false
    
    var finalNodeId: Int?
    var visitedNodesIds = [Int]()
    var timer: Timer?
    
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
        algorithmIsRunning = false
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
    
    // MARK: Existing connections
    
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
}

// MARK: - Graph instance creation

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
        let positions = UIHelper.coverUnhiddenNodesPositions
        var edges = [[Edge]]()
        
        for _ in 0...25 {edges.append([Edge]())}
        
        let graph = Graph(nodes: [Node](), edges: edges)
        
        let node0 = Node(id: 0, position: positions[0])
        graph.addNode(node0)
        
        for i in 1...9 {
            let node = Node(id: i, position: positions[i])
            graph.addNode(node)
            let edge = Edge(from: graph.nodes[i], to: graph.nodes[i-1])
            graph.addEdge(edge)
        }
        
        let node10 = Node(id: 10, position: positions[10])
        graph.addNode(node10)
        let edge10 = Edge(from: graph.nodes[10], to: graph.nodes[3])
        graph.addEdge(edge10)
        
        for i in 11...13 {
            let node = Node(id: i, position: positions[i])
            graph.addNode(node)
            let edge = Edge(from: graph.nodes[i], to: graph.nodes[i-1])
            graph.addEdge(edge)
        }
        
        let node14 = Node(id: 14, position: positions[14])
        graph.addNode(node14)
        let edge14 = Edge(from: graph.nodes[14], to: graph.nodes[10])
        graph.addEdge(edge14)
        
        let node15 = Node(id: 15, position: positions[15])
        graph.addNode(node15)
        let edge15 = Edge(from: graph.nodes[15], to: graph.nodes[14])
        graph.addEdge(edge15)
        
        let node16 = Node(id: 16, position: positions[16])
        graph.addNode(node16)
        let edge16 = Edge(from: graph.nodes[16], to: graph.nodes[3])
        graph.addEdge(edge16)
        
        for i in 17...19 {
            let node = Node(id: i, position: positions[i])
            graph.addNode(node)
            let edge = Edge(from: graph.nodes[i], to: graph.nodes[i-1])
            graph.addEdge(edge)
        }
        
        let node20 = Node(id: 20, position: positions[20])
        graph.addNode(node20)
        let edge20 = Edge(from: graph.nodes[20], to: graph.nodes[18])
        graph.addEdge(edge20)
        
        for i in 21...23 {
            let node = Node(id: i, position: positions[i])
            graph.addNode(node)
            let edge = Edge(from: graph.nodes[i], to: graph.nodes[i-1])
            graph.addEdge(edge)
        }
        
        let node24 = Node(id: 24, position: positions[24])
        graph.addNode(node24)
        let edge24 = Edge(from: graph.nodes[24], to: graph.nodes[22])
        graph.addEdge(edge24)
        
        let node25 = Node(id: 25, position: positions[25])
        node25.toggleFinalStatus()
        graph.addNode(node25)
        let edge25 = Edge(from: graph.nodes[25], to: graph.nodes[24])
        graph.addEdge(edge25)
        
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
