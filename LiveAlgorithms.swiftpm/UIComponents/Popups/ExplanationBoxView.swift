//
//  ExplanationBoxView.swift
//  
//
//  Created by Matheus S. Moreira on 16/04/23.
//

import SwiftUI

struct ExplanationBoxView: View {
    @ObservedObject var vm: GraphViewViewModel
    let algorithm: Algorithm
    
    var body: some View {
        Rectangle()
            .fill(Color.blackGray)
            .blur(radius: 10)
            .frame(maxWidth: UIHelper.explanationBoxWidth,
                   maxHeight: UIHelper.explanationBoxHeight)
            .overlay {
                VStack {
                    Text(algorithm.rawValue)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                    
                    Text(UIHelper.getAlgorithmExplanationText(for: algorithm))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                        .padding(.vertical)
                    
                    Button(action: {
                        withAnimation {
                            vm.showAlgorithmExplanationBox = false
                        }
                    } ) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.clear)
                            .border(Color.white)
                            .frame(width: 100, height: 50)
                            .padding()
                            .overlay {
                                Text("Ok")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                    }
                }
            }
    }
}
