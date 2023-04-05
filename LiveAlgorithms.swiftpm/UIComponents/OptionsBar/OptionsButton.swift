//
//  OptionsButton.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import SwiftUI

struct OptionsButton: View {
    var image: Image
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action ) {
            HStack {
                image
                    .foregroundColor(.white)
                    .font(.title2)
                Text(text)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
    }
}
