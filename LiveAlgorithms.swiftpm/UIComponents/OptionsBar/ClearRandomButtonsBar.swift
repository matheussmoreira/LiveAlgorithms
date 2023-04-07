//
//  ClearRandomButtonsBar.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct ClearRandomButtonsBar: View {
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
                BottomBarButton(image: .clear, text: "Clear") {
                    withAnimation { vm.clearButtonTapped() }
                }.padding(.trailing)
                Spacer()
                
                BottomBarButton(image: .random, text: "Random") {
                    withAnimation { vm.randomButtonTapped() }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)
    }
}
