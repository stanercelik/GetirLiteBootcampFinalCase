//
//  VerticalEntity.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 24.04.2024.
//

import Foundation

struct VerticalWelcomeElement: Codable {
    let id: String?
    let name: String?
    let productCount: Int?
    let products: [VerticalProduct]?
}

struct VerticalProduct: Codable {
    let id: String?
    let name: String?
    let attribute: String?
    let thumbnailURL: String?
    let imageURL: String?
    let price: Double?
    let priceText: String?
    let shortDescription: String?
}

typealias VerticalWelcome = [VerticalWelcomeElement]
