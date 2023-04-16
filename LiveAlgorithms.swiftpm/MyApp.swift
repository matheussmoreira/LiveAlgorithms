import SwiftUI

@main
struct MyApp: App {
    @State private var currentPage: Page = .coverPage
    @State private var showGenericInstructionPopup = true
    
    var body: some Scene {
        WindowGroup {
            if currentPage == .coverPage {
                CoverView()
                    .onAppear { routeWithDelay() }
                
            } else if currentPage == .tutorialPage {
                TutorialView(page: $currentPage)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                
            } else if currentPage == .graphPage {
                GraphView(page: $currentPage, showPopupAgain: $showGenericInstructionPopup)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                
            } else { // .finalPage
                FinalView()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
    
    private func routeWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
            currentPage = .tutorialPage
        })
    }
}
