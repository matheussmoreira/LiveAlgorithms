//
//  Enums.swift
//  
//
//  Created by Matheus S. Moreira on 01/04/23.
//

import Foundation

// MARK: - Node

enum NodeType {
    case hidden, notVisited, visited
}

enum NodePlace {
    case initial, normal, final
}

// MARK: - Edge

enum EdgeError: Error {
    case nilSourceNode
}

// MARK: - Navigation

enum Page {
    case coverPage
    case tutorialPage
    case graphPage
    case finalPage
}

enum Step: CaseIterable {
    case nodeSelection
    case edgeSelection
    case askingForAlgorithmSelection
    case algorithmsList
    case initialFinalNodesSelection
    case onlyInitialNodeSelection
    case edgesWeigthsSelection
    case liveAlgorithm
}

// MARK: - Algorithms

enum Algorithm: String, CaseIterable, Identifiable {
    case dfs = "Depth-first search"
    case bfs = "Breadth-first search"
    case djikstra = "Djikstra's shortest path"
    case prim = "Prim's minimum spanning tree"
    
    var id: String { self.rawValue }
}

enum AlgorithmState {
    case notStarted, running, paused
}
