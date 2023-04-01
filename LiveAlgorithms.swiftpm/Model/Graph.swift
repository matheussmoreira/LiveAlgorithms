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
    
    // MARK: - Nodes
    
    func addNode(_ node: Node) {
        nodes.append(node)
        edges.append([Edge]())
    }
    
    func retrieveAllNodes() {
        nodes.forEach { $0.showAsNotVisited() }
    }
    
    func randomizeNodeSelection() {
        nodes.forEach { $0.randomizeSelection() }
    }
    
//    func removeNode(_ node: Node) {
//        nodes.remove(at: node.id)
//        for e in edges[node.id] { removeEdge(e) }
//        edges.remove(at: node.id)
//    }
    
    // MARK: - Edges
    
    // MARK: Get edges
    
    func addEdge(_ edge: Edge) {
        guard let rev = edge.reversed else { return }
        edges[edge.source.id].append(edge)
        edges[edge.dest.id].append(rev)
    }
    
    private func addEdge(_ edge: Edge, on edgesArray: inout [[Edge]]) {
        guard let rev = edge.reversed else { return }
        edgesArray[edge.source.id].append(edge)
        edgesArray[edge.dest.id].append(rev)
    }
    
    func getRandomEdges() -> [[Edge]] {
        var newEdges = [[Edge]]()
        
        for sourceNode in nodes {
            var destNodesQuant = Int.random(in: 1..<nodes.count)
            
            repeat {
                guard let destNode = nodes.randomElement() else { continue }
                if destNode == sourceNode { continue }
                
                do {
                    // Create edge
                    if !edgeConnects(sourceNode: sourceNode,
                                     destNode: destNode,
                                     on: newEdges) {
                        let edge = try Edge(from: sourceNode, to: destNode)
                        addEdge(edge, on: &newEdges)
                    } else {
                        continue
                    }
                } catch {
                    // EdgeError: attempt to draw invalid edge!
                    continue
                }
                
                destNodesQuant -= 1
            } while (destNodesQuant < 0)
        }
        
        return newEdges
    }
    
    // MARK: Existing connections on edges
    
    func edgeConnects(sourceNode: Node, destNode: Node) -> Bool {
        for sourceNodeEdge in edges[sourceNode.id] {
            if sourceNodeEdge.dest == destNode { return true }
        }
        
        return false
    }
    
    private func edgeConnects(sourceNode: Node, destNode: Node, on edgesArray: [[Edge]]) -> Bool {
        #warning("Index out of range")
        for sourceNodeEdge in edgesArray[sourceNode.id] {
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
