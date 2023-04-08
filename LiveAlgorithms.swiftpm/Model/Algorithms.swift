//
//  Algorithms.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

// MARK: - Algorithms

extension Graph {
    
    private func animateAlgorithm() {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true, block: { timer in
            if self.visitedNodesIds.isEmpty {
                timer.invalidate()
                self.foundFinalNode = false
                return
            }
            
            let id = self.visitedNodesIds.removeFirst()
            self.nodes[id].setAsVisited()
        })
    }
    
    // MARK: DFS
    
    func animateDFS(startingFrom node: Node) {
        dfs(startingFrom: node)
        animateAlgorithm()
    }
    
    func dfs(startingFrom node: Node) {
        visitedNodesIds.append(node.id)
        
        if node.isFinal {
            foundFinalNode = true
            return
        }
        
        for edge in edges[node.id] {
            if foundFinalNode { break }
            if !visitedNodesIds.contains(edge.dest.id) {
                dfs(startingFrom: edge.dest)
            }
        }
    }
    
    // MARK: BFS
    
    func animateBFS(startingFrom node: Node) {
        bfs(startingFrom: node)
        animateAlgorithm()
    }
    
    private func bfs(startingFrom node: Node) {
        var queue: Queue<Node> = Queue()
        queue.enqueue(node)
        visitedNodesIds.append(node.id)
        
        while(!queue.isEmpty) {
            guard let dequeuedNode = queue.dequeue() else { break }
            for edge in edges[dequeuedNode.id] {
                if !visitedNodesIds.contains(edge.dest.id) {
                    queue.enqueue(edge.dest)
                    visitedNodesIds.append(edge.dest.id)
                    if edge.dest.isFinal { return }
                }
            }
        }
    }
    
}
