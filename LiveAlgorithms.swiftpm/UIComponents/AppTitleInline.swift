//
//  AppTitleInline.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct AppTitleInline: View {
    var body: some View {
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
    }
}
