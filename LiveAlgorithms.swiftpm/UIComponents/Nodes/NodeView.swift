//
//  NodeView.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    
    private var nodeIsVisited: Bool {
        node.type == .visited
    }
    private var nodeIsUnhidden: Bool {
        node.type != .hidden
    }
    
    var body: some View {
        if node.place == .initial {
            InitialNodeView(isVisited: nodeIsVisited)
        } else if node.place == .final {
            FinalNodeView(isVisited: nodeIsVisited)
        } else {
            if nodeIsUnhidden {
                NormalNodeView(isVisited: nodeIsVisited)
            } else {
                HiddenNodeView()
            }
        }
    }
}
