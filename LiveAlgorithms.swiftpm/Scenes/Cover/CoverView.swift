//
//  CoverView.swift
//  
//
//  Created by Matheus S. Moreira on 08/04/23.
//

import SwiftUI

struct CoverView: View {
    private let graphHiddenNodes = Graph.generateHiddenForCover()
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            ForEach(graphHiddenNodes.nodes) { node in
                NodeView(node: node, decreasedZIndex: false)
                    .position(node.position)
            }
            
            VStack {
                Spacer()
                Image.appTitleRect
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.ignoresSafeArea()
            
            Image("GreenCircle")
                .frame(width: UIHelper.greenCircleSize.width,
                       height: UIHelper.greenCircleSize.width)
                .position(x: UIHelper.greenCirclePosition.x,
                          y: UIHelper.greenCirclePosition.y)
        }
    }
}
