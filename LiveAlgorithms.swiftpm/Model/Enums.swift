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
    case equalSourceDest
    case nilSourceNode
}

// MARK: - Graph

enum GraphMakingStep: CaseIterable {
    case nodeSelection
    case edgeSelection
    case askingForAlgorithmSelection
    case algorithmsList
    case initialFinalNodesSelection
    case onlyInitialNodeSelection
    case edgesWeigthsSelection
    case algorithmSelected
}

enum Algorithm: String, CaseIterable, Identifiable {
    case bfs = "Breadth-first search"
    case dfs = "Depth-first search"
    case djikstra = "Djikstra's shortest path"
    case mst = "Prim's minimum spanning tree"
    
    var id: String { self.rawValue }
}
