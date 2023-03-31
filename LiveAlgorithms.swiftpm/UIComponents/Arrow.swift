//
//  Arrow.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import SwiftUI

struct Arrow: View {
    var next: Bool
    
    var body: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .overlay {
                if next {
                    Image.next
                        .fontWeight(.bold)
                        
                } else {
                    Image.previous
                        .fontWeight(.bold)
                }
            }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow(next: true)
    }
}
