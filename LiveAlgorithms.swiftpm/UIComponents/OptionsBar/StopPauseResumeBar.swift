//
//  StopPauseResumeBar.swift
//  
//
//  Created by Matheus S. Moreira on 07/04/23.
//

import SwiftUI
import Combine

struct StopPauseResumeBar: View {
    @ObservedObject var vm: GraphViewViewModel
    @State private var secButtonImage: Image = .pause
    @State private var secButtonText: String = "Pause"
    @State private var cancellables = Set<AnyCancellable>()
    
    private let w = UIHelper.screenWidth * 415/744
    private let h = UIHelper.screenWidth * 70/1133
    
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
                
                BottomBarButton(image: secButtonImage, text: secButtonText) {
                    withAnimation { vm.pauseResumeAlgorithm() }
                }.padding(.leading)
                Spacer()
            }
        }
        .frame(height: h)
        .frame(maxWidth: w)
        .onAppear {
            observeAlgorithmRunningStatus()
        }
    }
    
    func observeAlgorithmRunningStatus() {
        vm.graph.$algorithmIsRunning.sink { running in
            if running {
                secButtonImage = .pause
                secButtonText = "Pause"
            } else {
                secButtonImage = .run
                secButtonText = "Resume"
            }
        }.store(in: &cancellables)
    }
}
