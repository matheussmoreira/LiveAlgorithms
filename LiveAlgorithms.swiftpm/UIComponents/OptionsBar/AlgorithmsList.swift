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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            VStack {
                Spacer()
                Text("Select algorithm")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                
                ForEach(list) { alg in
                    HStack {
                        Button(action: {
                            withAnimation {
                                vm.selectedAlgorithmForExplanation = alg
                                vm.showAlgorithmExplanationBox = true
                            }
                        }) {
                            Image.question
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Button(action: {
                            withAnimation {
                                vm.selectAlgorithm(alg)
                            }
                        }) {
                            Text(alg.id)
                                .fontWeight(.semibold)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(height: UIHelper.algorithmsListHeight)
        .frame(maxWidth: UIHelper.algorithmsListWidth)
    }
}
