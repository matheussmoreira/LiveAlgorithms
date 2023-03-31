//
//  NodeSelectionOptionsBar.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct NodeSelectionOptionsBar: View {
    @ObservedObject var graph: Graph
    private let w = UIHelper.screenWidth * 415/744
    private let h = UIHelper.screenWidth * 70/1133
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            HStack {
                Spacer()
                OptionsButton(action: { clearNodes() }, image: .clear, text: "Clear")
                Spacer()
                OptionsButton(action: {}, image: .undo, text: "Undo")
                Spacer()
                OptionsButton(action: {}, image: .random, text: "Random")
                Spacer()
            }
        }
        .frame(width: w, height: h)
    }
}

extension NodeSelectionOptionsBar {
    func clearNodes() {
        withAnimation {
            graph.retrieveAllNodes()
        }
    }
}

struct OptionsButton: View {
    var action: () -> Void
    var image: Image
    var text: String
    
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
                    .underline()
            }
        } // Button
    }
}
