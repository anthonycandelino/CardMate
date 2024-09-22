//
//  ContentView.swift
//  CardMate
//
//  Created by Anthony Candelino on 2024-09-19.
//

import SwiftUI
import CoreImage
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    @State private var selectedCardImage : PhotosPickerItem?
    @State private var cards: [Card] = []
    @State private var promptForName = false
    @State private var selectedCardName = ""
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if !cards.isEmpty {
                        ForEach(cards.sorted(), id: \.self) { card in
                            withAnimation() {
                                CardPreviewView(card: card)
                            }
                        }
                    } else {
                        VStack {
                            ContentUnavailableView("No cards added yet", systemImage: "photo.on.rectangle.angled", description: Text("Add a card to get started"))
                                .foregroundStyle(.gray)
                                .frame(minHeight: UIScreen.main.bounds.height * 0.70)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .navigationDestination(for: Card.self) { card in
                CardDetailsView(card: card)
            }
            .onChange(of: selectedCardImage) { oldValue, newValue in
                if newValue != nil {
                    promptForName = true
                    locationFetcher.start()
                }
            }
            .sheet(isPresented: $promptForName, onDismiss: resetNameAndImage) {
                VStack(spacing: 16) {
                    Text("Enter Card Name")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    TextField("Name", text: $selectedCardName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            await saveCard()
                            DispatchQueue.main.async {
                                promptForName = false
                                dismiss()
                                if cards.count % 5 == 0 {
                                    requestReview()
                                }
                            }
                        }
                    }) {
                        Text("Save Card")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("CardMate")
            .toolbar {
                ToolbarItem() {
                    PhotosPicker(selection: $selectedCardImage) {
                        if cards.isEmpty {
                            Image(systemName: "photo.badge.plus")
                                .font(.title2)
                                .symbolEffect(.wiggle.clockwise.byLayer, options: .repeat(.periodic(delay: 1.5)))
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .font(.title2)
                        }
                    }
                }
            }
            .onAppear(perform: loadCards)
        }
    }
    
    func saveCard() async {
        let url = URL.documentsDirectory.appending(path: "cards.txt")
        
        do {
            guard let imageData = try await selectedCardImage?.loadTransferable(type: Data.self) else { return }
            let currentLocation = getCurrentLocation()
            cards.append(Card(name: selectedCardName, imageData: imageData, latitude: currentLocation.latitude, longitude: currentLocation.longitude))
            let data = try JSONEncoder().encode(cards)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save cards: \(error.localizedDescription)")
        }
    }
    
    func loadCards() {
        let url = URL.documentsDirectory.appending(path: "cards.txt")
        
        do {
            let data = try Data(contentsOf: url)
            cards = try JSONDecoder().decode([Card].self, from: data)
            print("Cards loaded successfully.")
        } catch {
            print("No cards to load or failed to load: \(error.localizedDescription)")
        }
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        if let location = locationFetcher.lastKnownLocation {
            return location
        } else {
            return CLLocationCoordinate2D(latitude: 43.4643, longitude: -80.5204)
        }
    }
    
    func resetNameAndImage() {
        selectedCardName = ""
        selectedCardImage = nil
    }
    
}

#Preview {
    ContentView()
}
