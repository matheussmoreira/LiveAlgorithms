//
//  FinalView.swift
//  
//
//  Created by Matheus S. Moreira on 14/04/23.
//

import SwiftUI

struct FinalView: View {
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            Image("Thank You")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        
    }
}
