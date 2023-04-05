//
//  PickAlgorithmOptionsBar.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import SwiftUI

struct PickAlgorithmOptionsBar: View {
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
                OptionsButton(image: .turnUp, text: "Select algorithm") {
                    withAnimation {
                        vm.isSelectingAlgorithm = true
                    }
                }.padding(.trailing)
                Spacer()
                
                OptionsButton(image: .run, text: "Run") {
                    withAnimation { }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)

    }
}
