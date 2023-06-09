//
//  UIHelper.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct UIHelper {
    
    // MARK: - Sizes
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let graphExampleImageWidth = screenWidth * 0.55
    static let tutorialTextWidth = screenWidth * 0.85
    static let agreementPopupWidth = screenWidth * 0.75
    static let agreementPopupHeight = screenHeight * 0.3
    static let explanationBoxWidth = screenWidth * 0.85
    static let explanationBoxHeight = screenHeight * 0.45
    static let algorithmsListWidth = screenWidth * 0.86
    static let algorithmsListHeight = screenWidth * 0.35
    
    // MARK: - Positions
    
    static let greenCirclePosition = CGPoint(x: screenWidth * 260/744, y: screenHeight * 1022/1133)
    
    static var nodesPositions: [CGPoint] {
        return [
            Self.pointOnScreen(x: 624, y: 407), Self.pointOnScreen(x: 552, y: 315),
            Self.pointOnScreen(x: 258, y: 315), Self.pointOnScreen(x: 114, y: 330),
            Self.pointOnScreen(x: 67,  y: 432), Self.pointOnScreen(x: 200, y: 416),
            Self.pointOnScreen(x: 286, y: 447), Self.pointOnScreen(x: 375, y: 529),
            Self.pointOnScreen(x: 437, y: 508), Self.pointOnScreen(x: 437, y: 576),
            Self.pointOnScreen(x: 558, y: 612), Self.pointOnScreen(x: 507, y: 461),
            Self.pointOnScreen(x: 75,  y: 887), Self.pointOnScreen(x: 36,  y: 766),
            Self.pointOnScreen(x: 200, y: 829), Self.pointOnScreen(x: 276, y: 887),
            Self.pointOnScreen(x: 677, y: 884), Self.pointOnScreen(x: 515, y: 869),
            Self.pointOnScreen(x: 573, y: 799), Self.pointOnScreen(x: 360, y: 828),
            Self.pointOnScreen(x: 184, y: 739), Self.pointOnScreen(x: 224, y: 514),
            Self.pointOnScreen(x: 398, y: 361), Self.pointOnScreen(x: 396, y: 290),
            Self.pointOnScreen(x: 239, y: 613), Self.pointOnScreen(x: 527, y: 535),
            Self.pointOnScreen(x: 639, y: 629), Self.pointOnScreen(x: 641, y: 508),
            Self.pointOnScreen(x: 641, y: 729), Self.pointOnScreen(x: 552, y: 698),
            Self.pointOnScreen(x: 460, y: 643), Self.pointOnScreen(x: 397, y: 903),
            Self.pointOnScreen(x: 170, y: 613), Self.pointOnScreen(x: 99,  y: 694),
            Self.pointOnScreen(x: 83,  y: 583), Self.pointOnScreen(x: 139, y: 504),
            Self.pointOnScreen(x: 315, y: 376), Self.pointOnScreen(x: 484, y: 401),
            Self.pointOnScreen(x: 397, y: 455), Self.pointOnScreen(x: 292, y: 550),
            Self.pointOnScreen(x: 337, y: 620), Self.pointOnScreen(x: 681, y: 310),
            Self.pointOnScreen(x: 382, y: 758), Self.pointOnScreen(x: 461, y: 798),
            Self.pointOnScreen(x: 476, y: 729), Self.pointOnScreen(x: 403, y: 690),
            Self.pointOnScreen(x: 270, y: 788), Self.pointOnScreen(x: 322, y: 714),
            Self.pointOnScreen(x: 255, y: 691)
        ]
    }
    
    static var coverHiddenNodesPositions: [CGPoint] {
        return [
            Self.pointOnScreen(x: 28,  y: 790), Self.pointOnScreen(x: 127, y: 804),
            Self.pointOnScreen(x: 276, y: 804), Self.pointOnScreen(x: 401, y: 814),
            Self.pointOnScreen(x: 522, y: 818), Self.pointOnScreen(x: 660, y: 804),
            Self.pointOnScreen(x: 42,  y: 703), Self.pointOnScreen(x: 142, y: 731),
            Self.pointOnScreen(x: 240, y: 731), Self.pointOnScreen(x: 385, y: 731),
            Self.pointOnScreen(x: 480, y: 762), Self.pointOnScreen(x: 608, y: 748),
            Self.pointOnScreen(x: 671, y: 703), Self.pointOnScreen(x: 42,  y: 616),
            Self.pointOnScreen(x: 106, y: 630), Self.pointOnScreen(x: 226, y: 649),
            Self.pointOnScreen(x: 539, y: 677), Self.pointOnScreen(x: 646, y: 603),
            Self.pointOnScreen(x: 78,  y: 500), Self.pointOnScreen(x: 261, y: 446),
            Self.pointOnScreen(x: 399, y: 459), Self.pointOnScreen(x: 454, y: 501),
            Self.pointOnScreen(x: 564, y: 534), Self.pointOnScreen(x: 618, y: 449),
            Self.pointOnScreen(x: 674, y: 500), Self.pointOnScreen(x: 50,  y: 385),
            Self.pointOnScreen(x: 148, y: 385), Self.pointOnScreen(x: 240, y: 356),
            Self.pointOnScreen(x: 318, y: 384), Self.pointOnScreen(x: 518, y: 397),
            Self.pointOnScreen(x: 657, y: 418), Self.pointOnScreen(x: 419, y: 307),
            Self.pointOnScreen(x: 522, y: 315), Self.pointOnScreen(x: 594, y: 346),
            Self.pointOnScreen(x: 688, y: 335), Self.pointOnScreen(x: 42,  y: 251),
            Self.pointOnScreen(x: 134, y: 279), Self.pointOnScreen(x: 213, y: 243),
            Self.pointOnScreen(x: 309, y: 229), Self.pointOnScreen(x: 594, y: 265),
            Self.pointOnScreen(x: 688, y: 251), Self.pointOnScreen(x: 92,  y: 163),
            Self.pointOnScreen(x: 170, y: 166), Self.pointOnScreen(x: 248, y: 169),
            Self.pointOnScreen(x: 518, y: 215), Self.pointOnScreen(x: 646, y: 203),
            Self.pointOnScreen(x: 28,  y: 125), Self.pointOnScreen(x: 78,  y: 77),
            Self.pointOnScreen(x: 166, y: 84),  Self.pointOnScreen(x: 304, y: 98),
            Self.pointOnScreen(x: 402, y: 105), Self.pointOnScreen(x: 618, y: 133),
            Self.pointOnScreen(x: 30,  y: 24),  Self.pointOnScreen(x: 248, y: 24),
            Self.pointOnScreen(x: 414, y: 24),  Self.pointOnScreen(x: 525, y: 52),
            Self.pointOnScreen(x: 632, y: 24),  Self.pointOnScreen(x: 685, y: 80)
        ]
    }
    
    static var coverUnhiddenNodesPositions: [CGPoint] {
        return [greenCirclePosition,
                Self.pointOnScreen(x: 332, y: 926), Self.pointOnScreen(x: 303, y: 694),
                Self.pointOnScreen(x: 351, y: 627), Self.pointOnScreen(x: 405, y: 666),
                Self.pointOnScreen(x: 424, y: 605), Self.pointOnScreen(x: 476, y: 703),
                Self.pointOnScreen(x: 490, y: 641), Self.pointOnScreen(x: 559, y: 612),
                Self.pointOnScreen(x: 476, y: 563), Self.pointOnScreen(x: 289, y: 605),
                Self.pointOnScreen(x: 212, y: 535), Self.pointOnScreen(x: 148, y: 608),
                Self.pointOnScreen(x: 134, y: 508), Self.pointOnScreen(x: 275, y: 535),
                Self.pointOnScreen(x: 184, y: 436), Self.pointOnScreen(x: 364, y: 542),
                Self.pointOnScreen(x: 323, y: 478), Self.pointOnScreen(x: 419, y: 392),
                Self.pointOnScreen(x: 536, y: 464), Self.pointOnScreen(x: 485, y: 343),
                Self.pointOnScreen(x: 344, y: 320), Self.pointOnScreen(x: 409, y: 177),
                Self.pointOnScreen(x: 382, y: 117), Self.pointOnScreen(x: 539, y: 150),
                Self.pointOnScreen(x: 588, y: 64)
        ]
    }
    
    static func pointOnScreen(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: screenWidth * x/744, y: screenHeight * y/1133)
    }
}

// MARK: - Text

extension UIHelper {
    static func getTopBarText(for step: Step, algorithm: Algorithm?) -> String {
        switch step {
            case .nodeSelection:
                return .selectTheNodes
                
            case .edgeSelection:
                return .connectTheNodes
                
            case .askingForAlgorithmSelection:
                return algorithm?.rawValue ?? .pickAnAlgorithm
                
            case .initialFinalNodesSelection:
                return .selectInitialFinalNodes
                
            case .edgesWeigthsSelection:
                return .selectEdgesWeights
                
            case .onlyInitialNodeSelection:
                return .selectInitialNode
                
            case .liveAlgorithm:
                return algorithm?.rawValue ?? "Unknown algorithm"
                
            default: // .algorithmsList
                return "Select algorithm"
        }
    }
    
    static func getAlgorithmExplanationText(for algorithm: Algorithm) -> String {
        switch algorithm {
            case .dfs:
                return "Depth-first search performs a search in a graph. It starts from a source node and explores as far as possible (visiting the neighbors of the neighbors) along each branch before backtracking, i.e., visiting the remaining node's neighbors and repeating this process.\n\nA graph can have more than one DFS, depending on the order the neighbors were added to the neighborhoods. Also, each node must be marked as visited since a graph may contain cycles and, therefore, each node can be processed twice or more."
            case .bfs:
                return "The breadth-first search performs a search in a graph. It starts from a source node and visits all nodes at the current depth level (neighborhood) before moving to the nodes at the next depth level (neighbors of the neighbors).\n\nA graph can have more than one BFS, depending on the order the neighbors were added to the neighborhoods. Also, each node must be marked as visited since a graph may contain cycles and, therefore, each node can be processed twice or more."
            case .djikstra:
                return "This algorithm finds the shortest path from a source node to all the other nodes in a graph considering the cost (edge's weights) to reach them. At the end of it's execution, it produces what we call Shortest Path Tree (SPT).\n\nIn comparison with Prim's algorithm, the sum of the costs of the edges in the SPT can be much larger than the cost of a Minimum Spanning Tree."
            case .prim:
                return "This algorithm finds the called Minimum Spanning Tree (MST), that is a subset of edges that forms a tree including all nodes, where the total weight of these edges is minimized.\n\nIn comparison with Djisktra's algorithm, the length of a path between any two nodes in the MST might not be the shortest path between them in the original graph."
        }
    }
    
}
