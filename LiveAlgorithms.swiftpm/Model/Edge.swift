//
//  Edge.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Edge: ObservableObject {
    
    // MARK: - Properties
    
    let source: Node
    let dest: Node

    @Published var sourcePosition: CGPoint
    @Published var destPosition: CGPoint
    @Published var weight: Int = 0
    @Published var inTree = true
    var isReversed = false
    
    var reversed: Edge {
        let rev = Edge(from: dest, to: source)
        rev.weight = weight
        rev.isReversed = true
        return rev
    }
    
    var weightPosition: CGPoint {
        let sourceX = sourcePosition.x
        let destX = destPosition.x
        let x = (destX + sourceX)/2
        
        let sourceY = sourcePosition.y
        let destY = destPosition.y
        let y = (destY + sourceY)/2
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Init
    
    init(from source: Node, to dest: Node) {
        self.source = source
        self.dest = dest
        self.sourcePosition = source.position
        self.destPosition = dest.position
    }
    
    // MARK: - Methods
    
    func setWeight(to newWeight: Int) {
        weight = newWeight
    }
    
    func eraseWeight() {
        weight = 0
    }
    
    func setAsOutOfTree() {
        inTree = false
    }
    
    func setAsInTree() {
        inTree = true
    }
}

// MARK: - Protocols

extension Edge: Equatable, Comparable {
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.source == rhs.source
                && lhs.dest == rhs.dest
    }
    
    static func ~= (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.source == rhs.dest
                && lhs.dest == rhs.source
    }
    
    static func < (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.weight < rhs.weight
    }
}
