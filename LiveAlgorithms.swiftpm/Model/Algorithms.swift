//
//  Algorithms.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

// MARK: - Algorithms

extension Graph {
    func checkForDisconnections(node: Node? = nil) {
        var checkingNode = node
        if checkingNode == nil { checkingNode = unhiddenNodes.randomElement() }
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
