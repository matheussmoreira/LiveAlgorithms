//
//  Algorithms.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

// MARK: - Algorithms

extension Graph {
    
    // MARK: DFS
    
    func runDFS(startingFrom node: Node) {
        selectedAlgorithm = .dfs
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
    
    func runBFS(startingFrom node: Node) {
        selectedAlgorithm = .bfs
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
    
    // MARK: - Djikstra
    
    func runDjikstra(startingFrom node: Node) {
        selectedAlgorithm = .djikstra
        djikstra(startingFrom: node)
        animateAlgorithm()
    }
    
    private func djikstra(startingFrom node: Node) {
        var distances = [Int:Int]()
        
        unhiddenNodes.forEach { node in
            distances[node.id] = .max
        }
        
        distances[node.id] = 0
        
        while visitedNodesIds.count < unhiddenNodes.count {
            let currentNodeId = minDistance(in: distances)
            visitedNodesIds.append(currentNodeId)
            
            for edge in edges[currentNodeId] where !visitedNodesIds.contains(edge.dest.id) {
                guard let currentDistance = distances[currentNodeId] else { continue }
                guard let destDistance = distances[edge.dest.id] else { continue }
                
                let distanceToNeighbor = currentDistance + edge.weight
                
                if destDistance > distanceToNeighbor {
                    distances[edge.dest.id] = distanceToNeighbor
                    edgesInTree[edge.dest.id] = edge
                }
            }
        }
    }
    
    private func minDistance(in distances: [Int:Int]) -> Int {
        var closestNodeId = -1
        var shortestDistance = Int.max
        
        for (nodeId,dist) in distances where !visitedNodesIds.contains(nodeId) {
            if dist < shortestDistance {
                closestNodeId = nodeId
                shortestDistance = dist
            }
        }
        
        return closestNodeId
    }
    
    // MARK: - Prim
    
    func runPrim(startingFrom node: Node) {
        selectedAlgorithm = .prim
        prim(startingFrom: node)
        animateAlgorithm()
    }
    
    private func prim(startingFrom node: Node) {
        var distances = [Int:Int]()
        
        for node in unhiddenNodes {
            distances[node.id] = .max
        }
        
        distances[node.id] = 0
        
        while visitedNodesIds.count < unhiddenNodes.count {
            let currentNodeId = minDistance(in: distances)
            visitedNodesIds.append(currentNodeId)
            
            for edge in edges[currentNodeId] where !visitedNodesIds.contains(edge.dest.id) {
                guard let destDistance = distances[edge.dest.id] else { continue }
                if destDistance > edge.weight {
                    distances[edge.dest.id] = edge.weight
                    edgesInTree[edge.dest.id] = edge
                }
            }
        }
    }
}

// MARK: - Animations

extension Graph  {
    private func animateAlgorithm() {
        algorithmState = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { algTimer in
            if self.algorithmState != .running { return }
            
            if self.visitedNodesIds.isEmpty {
                algTimer.invalidate()
                self.timer?.invalidate()
                self.algorithmState = .notStarted
                
                if self.selectedAlgorithm == .djikstra || self.selectedAlgorithm == .prim {
                    self.removeEdgesFromTree()
                }
                
                self.selectedAlgorithm = nil
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
}
