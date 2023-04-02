//
//  Edge.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Edge {
    let source: Node
    let dest: Node
    var sourcePosition: CGPoint
    var destPosition: CGPoint
    var weight: Int = 0
    
    var reversed: Edge {
        let rev = Edge(from: dest, to: source)
        rev.weight = weight
        return rev
    }
    
    init(from source: Node, to dest: Node) {
        self.source = source
        self.dest = dest
        self.sourcePosition = source.position
        self.destPosition = dest.position
    }
    
    func setWeight(to newWeight: Int) {
        weight = newWeight
    }
    
    func description() {
        print("Edge: \(source.id)-\(dest.id) (\(weight)")
    }
}

extension Edge: Equatable, Comparable {
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.source == rhs.source
                && lhs.dest == rhs.dest
                && lhs.weight == rhs.weight
    }
    
    static func < (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.weight < rhs.weight
    }
}
