import SwiftUI

@main
struct MyApp: App {
    #warning("Commit as true")
    @State private var isShowingCover = false
    
    var body: some Scene {
        WindowGroup {
            if isShowingCover {
                CoverView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
                            isShowingCover.toggle()
                        })
                    }
            } else {
                GraphView()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
}
