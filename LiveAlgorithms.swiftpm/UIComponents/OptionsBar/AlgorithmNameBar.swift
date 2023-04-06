//
//  AlgorithmNameBar.swift
//  
//
//  Created by Matheus S. Moreira on 06/04/23.
//

import SwiftUI

struct AlgorithmNameBar: View {
    var text: String
    private let w = UIHelper.screenWidth * 415/744
    private let h = UIHelper.screenWidth * 70/1133
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blackGray)
                .blur(radius: 10)
            
            Text(text)
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(height: h)
        .frame(maxWidth: w)
    }
}
