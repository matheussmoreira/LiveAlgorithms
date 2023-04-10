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
        algorithmIsRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { algTimer in
            if !self.algorithmIsRunning { return }
            
            if self.visitedNodesIds.isEmpty {
                algTimer.invalidate()
                self.timer?.invalidate()
                self.algorithmIsRunning = false
                return
            }
            
            let id = self.visitedNodesIds.removeFirst()
            self.nodes[id].setAsVisited()
            
            if id == self.finalNodeId {
                self.visitedFinalNodeId = self.finalNodeId
            }
        })
    }
    
    // MARK: DFS
    
    func animateDFS(startingFrom node: Node) {
        finalNodeId = nil
        visitedFinalNodeId = nil
        
        dfs(startingFrom: node)
        animateAlgorithm()
    }
    
    func dfs(startingFrom node: Node) {
        visitedNodesIds.append(node.id)
        
        if node.isFinal {
            finalNodeId = node.id
            return
        }
        
        for edge in edges[node.id] {
            if finalNodeId != nil { return }
            if !visitedNodesIds.contains(edge.dest.id) {
                dfs(startingFrom: edge.dest)
            }
        }
    }
    
    // MARK: BFS
    
    func animateBFS(startingFrom node: Node) {
        finalNodeId = nil
        visitedFinalNodeId = nil
        
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
                if visitedNodesIds.contains(edge.dest.id) { continue }
                queue.enqueue(edge.dest)
                visitedNodesIds.append(edge.dest.id)
                
                if edge.dest.isFinal {
                    finalNodeId = edge.dest.id
                    return
                }
            }
        }
    }
    
}
