//
//  AlertView.swift
//  
//
//  Created by Matheus S. Moreira on 06/04/23.
//

import SwiftUI

struct AlertView: View {
    @ObservedObject var vm: GraphViewViewModel
    
    var body: some View {
        Rectangle()
            .fill(Color.blackGray)
            .blur(radius: 10)
            .overlay {
                VStack {
                    Text(vm.alertText)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        withAnimation { vm.hideAlert() }
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.clear)
                            .border(Color.white)
                            .frame(width: 100, height: 50)
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
