//
//  StopPauseResumeBar.swift
//  
//
//  Created by Matheus S. Moreira on 07/04/23.
//

import SwiftUI

struct StopPauseResumeBar: View {
    @ObservedObject var vm: GraphViewViewModel
    
    private let w = UIHelper.screenWidth * 415/744
    private let h = UIHelper.screenWidth * 70/1133
    
    private var secondButtonImage: Image {
        vm.isRunningAlgorithm ? .pause: .run
    }
    
    private var secondButtonText: String {
        vm.isRunningAlgorithm ? "Pause" : "Resume"
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            HStack {
                Spacer()
                BottomBarButton(image: .stop, text: "Stop") {
                    withAnimation { vm.stopAlgorithm() }
                }.padding(.trailing)
                Spacer()
                
                BottomBarButton(image: secondButtonImage, text: secondButtonText) {
                    withAnimation { vm.pauseResumeAlgorithm() }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)
    }
}
