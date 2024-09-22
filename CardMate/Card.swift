//
//  Card.swift
//  CardMate
//
//  Created by Anthony Candelino on 2024-09-20.
//

import Foundation
import PhotosUI

struct Card: Codable, Hashable, Comparable {
    var id = UUID()
    let name: String
    let imageData: Data
    let latitude: Double
    let longitude: Double
    
    var image: UIImage? {
        UIImage(data: imageData)
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    
#if DEBUG
    static let example = Card(
        name: "CARD NAME",
        imageData: (UIImage(systemName: "star.fill")?.pngData()!)!,
        latitude: 43.4643,
        longitude: -80.5204
    )
#endif
}
