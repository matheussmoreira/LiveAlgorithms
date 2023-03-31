//
//  Node.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

enum NodeType {
    case hidden, notVisited, visited
}

enum NodePlace {
    case initial, normal, final
}

class Node: Identifiable {
    let id: Int
    let position: CGPoint
    let type: NodeType = .notVisited
    let place: NodePlace = .normal
    
    init(id: Int, position: CGPoint) {
        self.id = id
        self.position = position
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}
