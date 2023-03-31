//
//  InitialView.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct InitialView: View {
    let graph = Graph.graph()
    
    var body: some View {
        ZStack {
            Color.darkGray.ignoresSafeArea()
            ZStack {
                Image.appTitle1
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 56)
                Image.appTitle2
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: 8)
                    .padding(.horizontal, 56)
                Image.appTitle3
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: 16)
                    .padding(.horizontal, 56)
            }
            .padding(.horizontal)
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
