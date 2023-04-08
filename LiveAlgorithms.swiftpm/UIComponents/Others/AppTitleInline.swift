//
//  AppTitleInline.swift
//  
//
//  Created by Matheus S. Moreira on 30/03/23.
//

import SwiftUI

struct AppTitleInline: View {
    var body: some View {
        Image.appTitleInline
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
