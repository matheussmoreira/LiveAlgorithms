//
//  LetterView.swift
//  
//
//  Created by Matheus S. Moreira on 08/04/23.
//

import SwiftUI

struct LetterView: View {
    let letter: String
    
    var body: some View {
        Image(letter)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
