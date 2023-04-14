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
        selectedAlgorithm = .kruskal
        kruskal()
//        animateKruskal()
        removeEdgesFromTree()
    }
    
    private func kruskal() {
        let numNodes = unhiddenNodes.count
        var sortedEdges = edges.flatMap{ $0 }.sorted(by: { $0 < $1 })
        var treeSize = 0
        var index = 0
        var parent = [Int:Int]()
        var rank = [Int:Int]()
        
        Graph.removeReversedIn(&sortedEdges)
        
        for node in unhiddenNodes {
            parent[node.id] = node.id
            rank[node.id] = 0
        }
        
        while treeSize < numNodes-1 {
            let edge = sortedEdges[index]
            let sourceParent = findParent(&parent, edge.source.id)
            let destParent = findParent(&parent, edge.dest.id)
            let thereIsNoCycle = (sourceParent != destParent)
            
            if thereIsNoCycle {
                treeSize += 1
                edgesInTree[edge.dest.id] = edge
                union(parent: &parent, rank: &rank, node1: sourceParent, node2: destParent)
            }
            
            index += 1
        }
    }
    
    private func findParent(_ parent: inout [Int:Int], _ nodeId: Int) -> Int {
        if parent[nodeId] != nodeId {
            parent[nodeId] = findParent(&parent, parent[nodeId]!)
        }
        return parent[nodeId]!
    }
    
    private func union(parent: inout [Int:Int], rank: inout [Int:Int], node1: Int, node2: Int) {
        if rank[node1] == nil || rank[node2] == nil { return }
        
        if rank[node1]! < rank[node2]! {
            parent[node1] = node2
        } else if rank[node1]! > rank[node2]! {
            parent[node2] = node1
        } else {
            parent[node2] = node1
            rank[node1]! += 1
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
                
                if self.selectedAlgorithm == .djikstra {
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
                self.selectedAlgorithm = nil
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
