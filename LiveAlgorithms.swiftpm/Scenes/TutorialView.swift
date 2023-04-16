//
//  TutorialView.swift
//  
//
//  Created by Matheus S. Moreira on 15/04/23.
//

import SwiftUI

struct TutorialView: View {
    @Binding var page: Page
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                AppTitleInline()
                    .padding(.top, 32)
                
                VStack(spacing: 5) {
                    Text("Welcome to Live Algorithms!")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    
                    Text("Here, you will learn how some algorithms work in graphs.")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: UIHelper.tutorialTextWidth)
                }
                    
                VStack(spacing: 5) {
                    Text("What are graphs?")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    
                    Text("Graphs are generic data structures used to represent entities (nodes) and their connections (edges), like people in social networks or places in a map, as shown in the below figure:")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: UIHelper.tutorialTextWidth)
                }
                
                Image("Graph Example")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIHelper.graphExampleImageWidth)
                    .border(Color.white)
                
                Text("A graph may contain cycles, directed or undirected edges, edge with costs, separated subgraphs (making the whole a forest), and more. In the next steps, you will build your own graph and run some of the offered algorithms.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: UIHelper.tutorialTextWidth)
                
                Button(action: {
                    withAnimation { page = .graphPage }
                }) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blackGray)
                        .border(Color.white)
                        .frame(width: 250, height: 50)
                        .overlay {
                            Text("Let's go!")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding()
                        }
                }
                
                Spacer()
            }.padding(.horizontal)
        }
    }
}
