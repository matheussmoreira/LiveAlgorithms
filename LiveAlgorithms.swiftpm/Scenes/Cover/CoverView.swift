//
//  CoverView.swift
//  
//
//  Created by Matheus S. Moreira on 08/04/23.
//

import SwiftUI

struct CoverView: View {
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image.appTitleRect
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.ignoresSafeArea()
            
            Image("GreenCircle")
                .frame(width: UIHelper.greenCircleSize.width,
                       height: UIHelper.greenCircleSize.width)
                .position(x: UIHelper.greenCirclePosition.x,
                          y: UIHelper.greenCirclePosition.y)
        }
    }
}
