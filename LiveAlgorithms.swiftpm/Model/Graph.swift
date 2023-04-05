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
//    static let maxNodesQuantFirstScreen = 80
    static let nodeSize: CGFloat = 30
    
    // MARK: - Properties
    
    @Published var nodes: [Node]
    @Published var edges: [[Edge]]
    var visitedNodesIds = [Int]()
    
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
    
//    static func delay(secs: Double, action: @escaping () -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + secs, execute: {
//            action()
//        })
//    }
    
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
    
    func resetNodesVisitation() {
        visitedNodesIds = []
    }
    
    func unvisitAllNodes() {
        for node in unhiddenNodes {
            if node.isVisited {
                node.setAsNotVisited()
            }
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
        var randomEdges = generateRandomSpanningTree()
        
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
        
        return randomEdges
    }
    
    private func generateRandomSpanningTree() -> [[Edge]] {
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
