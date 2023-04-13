//
//  Algorithms.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

// MARK: - Algorithms

extension Graph {
    
    private func animateNodesVisitation() {
        algorithmIsRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { algTimer in
            if !self.algorithmIsRunning { return }
            
            if self.visitedNodesIds.isEmpty {
                algTimer.invalidate()
                self.timer?.invalidate()
                self.algorithmIsRunning = false
                self.removeEdgesFromSPT()
                return
            }
            
            let id = self.visitedNodesIds.removeFirst()
            self.nodes[id].setAsVisited()
            
            // DFS and BFS
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
        animateNodesVisitation()
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
        animateNodesVisitation()
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
    
    // MARK: - Djikstra
    
    func animateDjikstra(startingFrom node: Node) {
        djikstra(startingFrom: node)
        animateNodesVisitation()
    }
    
    private func djikstra(startingFrom node: Node) {
        var distances = [Int:Int]()
        
        unhiddenNodes.forEach { node in
            distances[node.id] = Int.max
        }
        
        distances[node.id] = 0
        visitedNodesIds = []
        
        while visitedNodesIds.count < unhiddenNodes.count {
            let currentNodeId = minDistance(distances: distances, visitedNodes: visitedNodesIds)
            visitedNodesIds.append(currentNodeId)
            
            for edge in edges[currentNodeId] {
                guard let currentDistance = distances[currentNodeId] else { continue }
                guard let destDistance = distances[edge.dest.id] else { continue }
                
                let distanceToNeighbor = currentDistance + edge.weight
                
                if distanceToNeighbor < destDistance {
                    distances[edge.dest.id] = distanceToNeighbor
                    edgesInSPT.append(edge)
                }
//                else {
//                    edgesOutOfSPT.append(edge)
//                }
            }
        }
    }
    
    func minDistance(distances: [Int:Int], visitedNodes: [Int]) -> Int {
        var closestNodeId = -1
        var shortestDistance = Int.max
        
        for (nodeId,dist) in distances {
            if !visitedNodes.contains(nodeId) && dist < shortestDistance {
                closestNodeId = nodeId
                shortestDistance = dist
            }
        }
        
        return closestNodeId
    }
    
}
