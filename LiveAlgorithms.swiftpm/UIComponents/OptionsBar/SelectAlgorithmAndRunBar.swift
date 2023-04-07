//
//  SelectAlgorithmAndRunBar.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import SwiftUI

struct SelectAlgorithmAndRunBar: View {
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
                BottomBarButton(image: .turnUp, text: "Select algorithm") {
                    withAnimation {
                        vm.showAlgorithmsList()
                    }
                }.padding(.trailing)
                Spacer()
                
                #warning("Desabilitar visualmente se não tiver algoritmo escolhido ainda")
                BottomBarButton(image: .run, text: "Run") {
                    withAnimation {
                        vm.runButtonTapped()
                    }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)

    }
}
