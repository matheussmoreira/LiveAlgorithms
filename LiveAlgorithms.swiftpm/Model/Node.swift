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
    
    var isNotVisited: Bool {
        return type == .notVisited
    }
    
    var isInitial: Bool {
        return place == .initial
    }
    
    var isFinal: Bool {
        return place == .final
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
    
    func randomizeSelection() {
        let types: [NodeType] = [.hidden, .notVisited]
        type = types.randomElement() ?? .hidden
    }
    
    func setAsVisited() {
        type = .visited
    }
    
    func setAsNotVisited() {
        type = .notVisited
    }
    
    func toggleInitialStatus() {
        if place == .initial {
            place = .normal
        } else {
            place = .initial
        }
    }
    
    func toggleFinalStatus() {
        if place == .final {
            place = .normal
        } else {
            place = .final
        }
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}
