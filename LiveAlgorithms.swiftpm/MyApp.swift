import SwiftUI

@main
struct MyApp: App {
    @State private var currentPage: Page = .coverPage
    
    var body: some Scene {
        WindowGroup {
            if currentPage == .coverPage {
                CoverView()
                    .onAppear { routeToGraphPage() }
                
            } else if currentPage == .graphPage {
                GraphView(page: $currentPage)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                
            } else { // .finalPage
                FinalView()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
    
    private func routeToGraphPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
            currentPage = .graphPage
        })
    }
}
