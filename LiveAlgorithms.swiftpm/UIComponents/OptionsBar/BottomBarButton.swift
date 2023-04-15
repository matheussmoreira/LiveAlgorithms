//
//  BottomBarButton.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import SwiftUI

struct BottomBarButton: View {
    var image: Image
    var text: String
    var disabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            if !disabled { self.action() }
        } ) {
            HStack {
                image
                    .foregroundColor(disabled ? .gray : .white)
                    .font(.title2)
                Text(text)
                    .foregroundColor(disabled ? .gray : .white)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
    }
}
