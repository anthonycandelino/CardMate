//
//  CardDetailsView.swift
//  CardMate
//
//  Created by Anthony Candelino on 2024-09-20.
//

import SwiftUI
import MapKit

struct CardDetailsView: View {
    let card: Card
    
    var body: some View {
        VStack {
            Text(card.name)
                .font(.largeTitle)
            
            Image(uiImage: card.image!)
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: UIScreen.main.bounds.width * 0.9,
                    maxHeight: UIScreen.main.bounds.height * 0.5
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
            Section("Meeting Point") {
                Divider()
                Map(initialPosition: getStartPosition()) {
                    Marker(card.name, coordinate: card.location)
                }
                .mapStyle(.standard)
                .frame(height: 200)
                .padding(.bottom)
            }
        }
        .padding()
    }
    
    func getStartPosition() -> MapCameraPosition {
        MapCameraPosition.region(
            MKCoordinateRegion(
                center: card.location,
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )
    }
}

#Preview {
    CardDetailsView(card: .example)
}
