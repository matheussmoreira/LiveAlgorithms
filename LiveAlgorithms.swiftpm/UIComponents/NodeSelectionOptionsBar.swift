//
//  NodeSelectionOptionsBar.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct NodeSelectionOptionsBar: View {
    @ObservedObject var graph: Graph
    @ObservedObject var vm: GraphViewViewModel
    
    private let w = UIHelper.screenWidth * 415/744
    private let h = UIHelper.screenWidth * 70/1133
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            HStack {
                Spacer()
                OptionsButton(image: .clear, text: "Clear") {
                    #warning("Tratar edgeSelection")
                    if vm.step != .nodeSelection { return }
                    withAnimation {
                        graph.retrieveAllNodes()
                    }
                }.padding(.trailing)
                Spacer()
                
                OptionsButton(image: .random, text: "Random") {
                    #warning("Tratar edgeSelection")
                    if vm.step != .nodeSelection { return }
                    withAnimation {
                        graph.randomizeAllNodeTypes()
                    }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)
    }
}

struct OptionsButton: View {
    var image: Image
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action ) {
            HStack {
                image
                    .foregroundColor(.white)
                    .font(.title2)
                Text(text)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
    }
}
