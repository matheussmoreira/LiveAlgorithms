//
//  AlgorithmsList.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import SwiftUI

struct AlgorithmsList: View {
    @ObservedObject var vm: GraphViewViewModel
    private let list = Algorithm.allCases
    private let w = UIHelper.screenWidth * 647/744
    private let h = UIHelper.screenWidth * 267/1133
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            VStack {
                Text("Select algorithm")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .foregroundColor(.white)
                
                ForEach(list) { alg in
                    Button(action: {
                        withAnimation {
                            vm.selectAlgorithm(alg)
                        }
                    }) {
                        Text(alg.id)
                            .fontWeight(.medium)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)
    }
}
