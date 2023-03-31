//
//  BlackBand.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct BlackBand: View {
    var text: String
    var body: some View {
        Rectangle()
            .fill(Color.blackGray)
        .blur(radius: 10)
        .overlay {
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.title3)
        }
    }
}
