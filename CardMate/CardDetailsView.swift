//
//  CardDetailsView.swift
//  CardMate
//
//  Created by Anthony Candelino on 2024-09-20.
//

import SwiftUI

struct CardDetailsView: View {
    let card: Card
    
    var body: some View {
        VStack {
            Text(card.name)
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.blue)
            
            Spacer()
            
            Image(uiImage: card.image!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CardDetailsView(card: .example)
}
