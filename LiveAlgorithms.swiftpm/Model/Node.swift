//
//  Node.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import Foundation

class Node: Identifiable, ObservableObject {
    let id: Int
    let position: CGPoint
    @Published var type: NodeType = .notVisited
    @Published var place: NodePlace = .normal
    
    var isHidden: Bool {
        return type == .hidden
    }
    
    init(id: Int, position: CGPoint) {
        self.id = id
        self.position = position
    }
    
    // MARK: - Methods
    
    func toggleHiddenStatus() {
        if type == .hidden {
            type = .notVisited
        } else {
            type = .hidden
        }
    }
    
    func showAsNotVisited() {
        type = .notVisited
    }
    
    func randomizeType() {
        let types: [NodeType] = [.hidden, .notVisited]
        type = types.randomElement() ?? .hidden
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}
