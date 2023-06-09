//
//  WeightCard.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct WeightCard: View {
    @ObservedObject var edge: Edge
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.white)
            .frame(width: 30, height: 30)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.darkGray, lineWidth: 2)
            }
            .overlay {
                Text(String(edge.weight))
                    .fontWeight(.semibold)
                    .font(.title3)
            }
    }
}
