//
//  NodeView.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct NodeView: View {
    @ObservedObject var node: Node
    
    private var nodeIsVisited: Bool {
        node.type == .visited
    }
    private var nodeIsUnhidden: Bool {
        node.type != .hidden
    }
    
    var body: some View {
        if node.place == .initial {
            InitialNode(isVisited: nodeIsVisited)
        } else if node.place == .final {
            FinalNode(isVisited: nodeIsVisited)
        } else {
            if nodeIsUnhidden {
                NormalNode(isVisited: nodeIsVisited)
            } else {
                HiddenNode()
            }
        }
    }
}
