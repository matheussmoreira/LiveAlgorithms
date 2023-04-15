//
//  GenericInstructionView.swift
//  
//
//  Created by Matheus S. Moreira on 15/04/23.
//

import SwiftUI

struct GenericInstructionView: View {
    @ObservedObject var vm: GraphViewViewModel
    
    var body: some View {
        Rectangle()
            .fill(Color.blackGray)
            .blur(radius: 10)
            .frame(maxWidth: UIHelper.agreementPopupWidth,
                   maxHeight: UIHelper.agreementPopupHeight)
            .overlay {
                VStack {
                    Text("Attention!")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                    
                    Text("To build a nice graph, just care about its organization, i.e., the total number of nodes/edges and edges intersections. If it is too messy, you will have a hard visualization.")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            vm.showGenericInstructionPopup = false
                        }
                    } ) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.clear)
                            .border(Color.white)
                            .frame(width: 250, height: 50)
                            .overlay {
                                Text("I understand")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                    }
                }
            }
    }
}
