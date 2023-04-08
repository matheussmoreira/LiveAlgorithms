import SwiftUI

@main
struct MyApp: App {
    @State private var isShowingCover = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingCover {
                CoverView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
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
