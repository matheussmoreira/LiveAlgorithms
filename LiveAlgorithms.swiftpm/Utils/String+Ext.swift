//
//  String+Ext.swift
//  
//
//  Created by Matheus S. Moreira on 07/04/23.
//

import Foundation

extension String {
    
    // MARK: Top bar
    
    static let selectTheNodes = "Select the nodes you want to remove from the graph"
    static let connectTheNodes = """
             Connect the nodes by tapping two of them in sequence
             Tap on an edge to remove it
             """
    static let pickAnAlgorithm = "Now, pick an algorithm to see it running live!"
    static let selectInitialFinalNodes = "Select the nodes where the algorithm will start and finish"
    static let selectEdgesWeights = "Tap on the numbers to select a random weight for the edges"
    static let selectInitialNode = "Select the node where the algorithm will start from"

    // MARK: Alerts
    
    static let mustHave2NodesAlert = "The graph must have at least 2 nodes!"
    static let disconnectedGraphAlert = """
         The graph is disconnected!\n
         There must not be either a node or\na subgraph disconnected from the whole.
         """
    
    static let noInitialFinalNodesAlert = "The graph must have both initial and final nodes set!"
    static let noInitialNodeAlert = "The graph must have an initial node set!"
}
