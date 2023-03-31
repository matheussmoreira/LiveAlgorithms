//
//  Graph.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Graph {
    static let maxNodesQuant = 35
    static let maxNodesQuantFirstScreen = 80
    
    var nodes: [Node]
    var edges: [[Edge]]
    
    init(nodes: [Node]) {
        self.nodes = nodes
        self.edges = [[Edge]]()
        
        for _ in nodes {
            edges.append([Edge]())
        }
    }
    
    static func graph() -> Graph {
        let node1 = Node(id: 0, position: CGPoint(x: 100, y: 100))
        let node2 = Node(id: 1, position: CGPoint(x: 200, y: 200))
        let node3 = Node(id: 2, position: CGPoint(x: 300, y: 300))
        let graph = Graph(nodes: [node1,node2,node3])
        
        do {
            let edge1 = try Edge(from: node1, to: node2)
            let edge2 = try Edge(from: node1, to: node3)
            graph.addEdge(edge1)
            graph.addEdge(edge2)
        } catch { }
        
        return graph
    }
    
    // MARK: - Add
    
    func addNode(_ node: Node) {
        nodes.append(node)
        edges.append([Edge]())
    }
    
    func addEdge(_ edge: Edge) {
        guard let rev = edge.reversed else { return }
        edges[edge.source.id].append(edge)
        edges[edge.dest.id].append(rev)
    }
    
    // MARK: - Remove
    
    func removeNode(_ node: Node) {
        nodes.remove(at: node.id)
        for e in edges[node.id] { removeEdge(e) }
        edges.remove(at: node.id)
    }
    
    func removeEdge(_ edge: Edge) {
        let sourceNode = nodes[edge.source.id]
        let destNode = nodes[edge.dest.id]
        
        edges[sourceNode.id].removeAll(where: { $0 == edge })
        edges[destNode.id].removeAll(where: { $0 == edge.reversed })
    }
    
    // MARK: Debug
    
    func description() {
        if nodes.isEmpty {
            print("Empty graph!")
            return
        }
        
        for node in nodes {
            print("Node \(node.id)")
        }
        
        for i in 0..<nodes.count {
            if edges[i].isEmpty {
                print("No edges")
                continue
            }
            
            for edge in edges[i] {
                print(edge.description())
            }
        }
    }
}
