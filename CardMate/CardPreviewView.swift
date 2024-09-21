//
//  CardPreviewView.swift
//  CardMate
//
//  Created by Anthony Candelino on 2024-09-20.
//

import SwiftUI

struct CardPreviewView: View {
    let card: Card
    
    var body: some View {
        NavigationLink(value: card) {
            HStack {
                Text(card.name)
                    .font(.headline)
                    .padding(.leading, 16)
                
                Spacer()
                
                Image(uiImage: card.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .shadow(radius: 5)
            .frame(width: UIScreen.main.bounds.width * 0.85)
            .padding(.top)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CardPreviewView(card: .example)
}
