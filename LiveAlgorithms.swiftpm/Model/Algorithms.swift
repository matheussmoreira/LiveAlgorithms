//
//  Algorithms.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

// MARK: - Algorithms

extension Graph {
    
    func dfs(startingFrom node: Node) {
        visitedNodesIds.append(node.id)
        if node.isFinal { return }
        
        for edge in edges[node.id] {
            if !visitedNodesIds.contains(edge.dest.id) {
                dfs(startingFrom: edge.dest)
            }
        }
    }
    
    func bfs(node: Node) {
        var queue: Queue<Node> = Queue()
        queue.enqueue(node)
        visitedNodesIds.append(node.id)
        
        while(!queue.isEmpty) {
            guard let dequeuedNode = queue.dequeue() else { break }
            for edge in edges[dequeuedNode.id] {
                if !visitedNodesIds.contains(edge.dest.id) {
                    queue.enqueue(edge.dest)
                    visitedNodesIds.append(edge.dest.id)
                }
            }
        }
    }
    
}
