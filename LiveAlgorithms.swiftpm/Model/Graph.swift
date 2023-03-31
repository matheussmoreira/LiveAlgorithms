//
//  Graph.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Graph {
    // MARK: Type Properties
    
    static let maxNodesQuant = 45
    static let maxNodesQuantFirstScreen = 80
    static let nodeSize: CGFloat = 30
    
    // MARK: Properties
    
    var nodes: [Node]
    var edges: [[Edge]]
    
    // MARK: Init
    
    init(nodes: [Node]) {
        self.nodes = nodes
        self.edges = [[Edge]]()
        
        for _ in nodes {
            edges.append([Edge]())
        }
    }
    
    // MARK: Nodes
    
    func addNode(_ node: Node) {
        nodes.append(node)
        edges.append([Edge]())
    }
    
    func removeNode(_ node: Node) {
        nodes.remove(at: node.id)
        for e in edges[node.id] { removeEdge(e) }
        edges.remove(at: node.id)
    }
    
    // MARK: Edges
    
    func addEdge(_ edge: Edge) {
        guard let rev = edge.reversed else { return }
        edges[edge.source.id].append(edge)
        edges[edge.dest.id].append(rev)
    }
    
    func removeEdge(_ edge: Edge) {
        let sourceNode = nodes[edge.source.id]
        let destNode = nodes[edge.dest.id]
        
        edges[sourceNode.id].removeAll(where: { $0 == edge })
        edges[destNode.id].removeAll(where: { $0 == edge.reversed })
    }
    
}

extension Graph {
    static func empty() -> Graph {
        let graph = Graph(nodes: [Node]())
        return graph
    }
    
    static func graph(inBounds bounds: CGSize) -> Graph {
        var nodes = [Node]()
        
        for i in 0..<maxNodesQuant {
            #warning("Tratar nós sobrepostos")
            let randomX = CGFloat.random(in: getRange(in: bounds.width))
            let randomY = CGFloat.random(in: getRange(in: bounds.height))
            let randomPoint = CGPoint(x: randomX, y: randomY)
            let node = Node(id: i, position: randomPoint)
            nodes.append(node)
            
            func getRange(in containerDimension: CGFloat) -> ClosedRange<CGFloat> {
                let lowerBound = Self.nodeSize
                let higherBound = containerDimension - Self.nodeSize
                return lowerBound...higherBound
            }
        }
        
        return Graph(nodes: nodes)
    }
}
