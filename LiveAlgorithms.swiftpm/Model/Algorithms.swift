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
        djikstra(startingFrom: node)
        animateAlgorithm()
    }
    
    private func djikstra(startingFrom node: Node) {
        var distances = [Int:Int]()
        
        unhiddenNodes.forEach { node in
            distances[node.id] = .max
            edgesInTree[node.id] = nil
        }
        
        distances[node.id] = 0
        
        while visitedNodesIds.count < unhiddenNodes.count {
            let currentNodeId = minDistance(distances: distances)
            visitedNodesIds.append(currentNodeId)
            
            for edge in edges[currentNodeId] where !visitedNodesIds.contains(edge.dest.id) {
                guard let currentDistance = distances[currentNodeId] else { continue }
                guard let destDistance = distances[edge.dest.id] else { continue }
                
                let distanceToNeighbor = currentDistance + edge.weight
                
                if distanceToNeighbor < destDistance {
                    distances[edge.dest.id] = distanceToNeighbor
                    edgesInTree[edge.dest.id] = edge
                }
            }
        }
    }
    
    private func minDistance(distances: [Int:Int]) -> Int {
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
    
    // MARK: - Kruskal
    
    func runKruskal() {
        kruskal()
        animateKruskal()
    }
    
    private func kruskal() {
        let numNodes = unhiddenNodes.count
        var sortedEdges = edges.flatMap{ $0 }.sorted(by: { $0 < $1 })
        var treeSize = 0
        var index = 0
        var parents = [Int:Int]()
        var rank = [Int:Int]()
        
        Graph.removeReversedIn(&sortedEdges)
        
        for node in unhiddenNodes {
            parents[node.id] = node.id
            rank[node.id] = 0
        }
        
        unhiddenNodes.forEach { node in
            edgesInTree[node.id] = nil
        }
        
        while treeSize < numNodes-1 {
            let edge = sortedEdges[index]
            let sourceParent = findParent(&parents, edge.source.id)
            let destParent = findParent(&parents, edge.dest.id)
            let thereIsNoCycle = (sourceParent != destParent)
            
            if thereIsNoCycle {
                treeSize += 1
                edgesInTree[edge.dest.id] = edge
                union(parents: &parents, rank: &rank, node1: sourceParent, node2: destParent)
            }
            
            index += 1
        }
    }
    
    private func findParent(_ parents: inout [Int:Int], _ nodeId: Int) -> Int {
        if parents[nodeId] != nodeId {
            parents[nodeId] = findParent(&parents, parents[nodeId]!)
        }
        return parents[nodeId]!
    }
    
    private func union(parents: inout [Int:Int], rank: inout [Int:Int], node1: Int, node2: Int) {
        let parent1 = findParent(&parents, node1)
        let parent2 = findParent(&parents, node2)
        
        if rank[parent1] == nil || rank[parent2] == nil { return }
        
        if rank[parent1]! < rank[parent2]! {
            parents[parent1] = parent2
        } else if rank[parent1]! > rank[parent2]! {
            parents[parent2] = parent1
        } else {
            parents[parent2] = parent1
            rank[parent1]! += 1
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
                self.removeEdgesFromTree()
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
    
    private func animateKruskal() {
        algorithmState = .running
        
        var sortedEdges = edges.flatMap{ $0 }.sorted(by: { $0 < $1 })
        Graph.removeReversedIn(&sortedEdges)
        
        let edgesOutOfTreeQuant = sortedEdges.count - edgesInTree.count - 1
        var edgesOutOfTreeCount = 0
        var index = -1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { algTimer in
            if self.algorithmState != .running { return }
            
            if edgesOutOfTreeCount == edgesOutOfTreeQuant {
                algTimer.invalidate()
                self.timer?.invalidate()
                self.algorithmState = .notStarted
                return
            }
            
            index += 1
            let ed = sortedEdges[index]
            
            if !self.edgesInTree.contains(where: { $0.value == ed}) {
                ed.setAsOutOfTree()
                edgesOutOfTreeCount += 1
            }
            
        })
    }
}
