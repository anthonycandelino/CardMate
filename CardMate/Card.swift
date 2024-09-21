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
    
    var image: UIImage? {
        UIImage(data: imageData)
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    
#if DEBUG
    static let example = Card(name: "CARD NAME", imageData: (UIImage(systemName: "star.fill")?.pngData()!)!)
#endif
}
