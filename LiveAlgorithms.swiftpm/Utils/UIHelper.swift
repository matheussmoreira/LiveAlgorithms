//
//  UIHelper.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct UIHelper {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let blackBoxHeight = screenHeight * 260/1133
    
//    static let appTitleTwoLinesSize = CGSize(width: screenWidth * 671/744, height: screenHeight * 231/1133)
//    static let appTitleTwoLinesPosition = CGPoint(x: screenWidth * 37/744,
//                                                  y: screenHeight * 890/1133)
    
    static let greenCircleSize = CGSize(width: screenWidth * 50/744, height: screenHeight * 50/1133)
    static let greenCirclePosition = CGPoint(x: screenWidth * 260/744,
                                                y: screenHeight * 1022/1133)
    
    static var nodesPositions: [CGPoint] {
        return [
            CGPoint(x: screenWidth * 624/744, y: screenHeight * 407/1133),
            CGPoint(x: screenWidth * 552/744, y: screenHeight * 315/1133),
            CGPoint(x: screenWidth * 258/744, y: screenHeight * 315/1133),
            CGPoint(x: screenWidth * 114/744, y: screenHeight * 330/1133),
            CGPoint(x: screenWidth * 67/744, y: screenHeight * 432/1133),
            CGPoint(x: screenWidth * 200/744, y: screenHeight * 416/1133),
            CGPoint(x: screenWidth * 286/744, y: screenHeight * 447/1133),
            CGPoint(x: screenWidth * 375/744, y: screenHeight * 529/1133),
            CGPoint(x: screenWidth * 437/744, y: screenHeight * 508/1133),
            CGPoint(x: screenWidth * 437/744, y: screenHeight * 576/1133),
            CGPoint(x: screenWidth * 558/744, y: screenHeight * 612/1133),
            CGPoint(x: screenWidth * 507/744, y: screenHeight * 461/1133),
            CGPoint(x: screenWidth * 75/744, y: screenHeight * 887/1133),
            CGPoint(x: screenWidth * 36/744, y: screenHeight * 766/1133),
            CGPoint(x: screenWidth * 200/744, y: screenHeight * 829/1133),
            CGPoint(x: screenWidth * 276/744, y: screenHeight * 887/1133),
            CGPoint(x: screenWidth * 677/744, y: screenHeight * 884/1133),
            CGPoint(x: screenWidth * 515/744, y: screenHeight * 869/1133),
            CGPoint(x: screenWidth * 573/744, y: screenHeight * 799/1133),
            CGPoint(x: screenWidth * 360/744, y: screenHeight * 828/1133),
            CGPoint(x: screenWidth * 184/744, y: screenHeight * 739/1133),
            CGPoint(x: screenWidth * 224/744, y: screenHeight * 514/1133),
            CGPoint(x: screenWidth * 398/744, y: screenHeight * 361/1133),
            CGPoint(x: screenWidth * 396/744, y: screenHeight * 290/1133),
            CGPoint(x: screenWidth * 239/744, y: screenHeight * 613/1133),
            CGPoint(x: screenWidth * 527/744, y: screenHeight * 535/1133),
            CGPoint(x: screenWidth * 639/744, y: screenHeight * 629/1133),
            CGPoint(x: screenWidth * 641/744, y: screenHeight * 508/1133),
            CGPoint(x: screenWidth * 641/744, y: screenHeight * 729/1133),
            CGPoint(x: screenWidth * 552/744, y: screenHeight * 698/1133),
            CGPoint(x: screenWidth * 460/744, y: screenHeight * 643/1133),
            CGPoint(x: screenWidth * 397/744, y: screenHeight * 903/1133),
            CGPoint(x: screenWidth * 170/744, y: screenHeight * 613/1133),
            CGPoint(x: screenWidth * 99/744, y: screenHeight * 694/1133),
            CGPoint(x: screenWidth * 83/744, y: screenHeight * 583/1133),
            CGPoint(x: screenWidth * 139/744, y: screenHeight * 504/1133),
            CGPoint(x: screenWidth * 315/744, y: screenHeight * 376/1133),
            CGPoint(x: screenWidth * 484/744, y: screenHeight * 401/1133),
            CGPoint(x: screenWidth * 397/744, y: screenHeight * 455/1133),
            CGPoint(x: screenWidth * 292/744, y: screenHeight * 550/1133),
            CGPoint(x: screenWidth * 337/744, y: screenHeight * 620/1133),
            CGPoint(x: screenWidth * 681/744, y: screenHeight * 310/1133), ///////
            CGPoint(x: screenWidth * 382/744, y: screenHeight * 758/1133),
            CGPoint(x: screenWidth * 461/744, y: screenHeight * 798/1133),
            CGPoint(x: screenWidth * 476/744, y: screenHeight * 729/1133),
            CGPoint(x: screenWidth * 403/744, y: screenHeight * 690/1133),
            CGPoint(x: screenWidth * 270/744, y: screenHeight * 788/1133),
            CGPoint(x: screenWidth * 322/744, y: screenHeight * 714/1133),
            CGPoint(x: screenWidth * 255/744, y: screenHeight * 691/1133),
        ]
    }
    
    static func getTopBarText(for step: GraphMakingStep, algorithm: Algorithm?) -> String {
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
                return algorithm?.rawValue ?? "Placeholder"
                
            default:
                return "Placeholder"
        }

    }
}
