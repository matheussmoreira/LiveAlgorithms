//
//  Graph.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

public protocol Copying: AnyObject {
    init(_ prototype: Self)
}

extension Copying {
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}

class Graph: ObservableObject, Copying {
    // MARK: - Type Properties
    
    static let maxNodesQuant = UIHelper.nodesPositions.count
//    static let maxNodesQuantFirstScreen = 80
    static let nodeSize: CGFloat = 30
    
    // MARK: - Properties
    
    @Published var nodes: [Node]
    @Published var edges: [[Edge]]
    private var visitedNodesIds = [Int]()
    
    var visitedAllNodes: Bool {
        return visitedNodesIds.count == unhiddenNodes.count
    }
    
    var unhiddenNodes: [Node] {
        return nodes.filter({!$0.isHidden})
    }
    
//    var unhiddenNodes: [Node] {
//        return nodes.filter({ $0.type != .hidden })
//    }
    
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
    
    // MARK: - Other methods
    
    func resetNodesVisitation() {
        visitedNodesIds = []
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
    
//    func removeNode(_ node: Node) {
//        nodes.remove(at: node.id)
//        for e in edges[node.id] { removeEdge(e) }
//        edges.remove(at: node.id)
//    }
    
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
    
    #warning("Não gerar grafo desconexo!")
    // Estratégia: primeiro criar um fio ligando todos os nós
    // Depois gerar aleatoriamente as arestas
    
    func getRandomEdges() -> [[Edge]] {
        var newEdges = Self.createEmptyEdgesMatrix(quantity: nodes.count)
        
        for sourceNode in nodes {
            if sourceNode.isHidden { continue }
            let destNodes = nodes.filter { !$0.isHidden && $0 != sourceNode }
            var destNodesQuant = destNodes.count
            
            repeat {
                guard let destNode = destNodes.randomElement() else { continue }
                if edgeConnects(sourceNode, to: destNode, on: newEdges) {
                    continue
                }
                
                let edge = Edge(from: sourceNode, to: destNode)
                addEdge(edge, on: &newEdges)
                
                destNodesQuant -= 1
            } while (destNodesQuant < 0)
        }
        
        return newEdges
    }
    
    static func createEmptyEdgesMatrix(quantity: Int) -> [[Edge]] {
        var newEdges = [[Edge]]()
        for _ in 0..<quantity {
            newEdges.append([Edge]())
        }
        return newEdges
    }
    
    // MARK: Existing connections on edges
    
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

// MARK: - Algorithms

extension Graph {
    func checkForDisconnections(node: Node? = nil) {
        var checkingNode = node
        if checkingNode == nil { checkingNode = nodes.randomElement() }
        guard let checkingNode = checkingNode else { return }
        
        visitedNodesIds.append(checkingNode.id)
        
        for edge in edges[checkingNode.id] {
            if !visitedNodesIds.contains(checkingNode.id) {
                self.checkForDisconnections(node: edge.dest)
            }
        }
    }
    
    func dfs(node: Node, counting: Bool = false) {
        node.setAsVisited()
        if node.isFinal { return }
        
        for edge in edges[node.id] {
            if edge.dest.isNotVisited {
                self.dfs(node: edge.dest)
            }
        }
    }
    
    func bfs(node: Node) {
        var queue: Queue<Node> = Queue()
        queue.enqueue(node)
        node.setAsVisited()
        
        while(!queue.isEmpty) {
            guard let dequeuedNode = queue.dequeue() else { break }
            for edge in edges[dequeuedNode.id] {
                if edge.dest.isNotVisited {
                    queue.enqueue(edge.dest)
                    edge.dest.setAsVisited()
                }
            }
        }
    }
}
