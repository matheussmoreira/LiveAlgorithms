import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.darkGray.ignoresSafeArea()
                
                VStack(spacing: 10) {
                    ZStack {
                        Image.appTitle1
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image.appTitle2
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: 8)
                        Image.appTitle3
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: 16)
                    }.padding(.horizontal)
                    
                    Text("Partiu")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Partiu")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .underline()
                        .foregroundColor(.white)
                }
            }
        }
    }
}
