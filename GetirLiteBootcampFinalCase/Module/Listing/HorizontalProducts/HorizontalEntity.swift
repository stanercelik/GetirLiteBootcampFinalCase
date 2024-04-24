//
//  HorizontalEntity.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 24.04.2024.
//

import Foundation

struct HorizontalWelcomeElement: Codable {
    let id: String?
    let name: String?
    let products: [HorizontalProduct]?
}

// MARK: - Product
struct HorizontalProduct: Codable {
    let id: String
    let imageURL: String?
    let price: Double?
    let name: String?
    let priceText: String?
    let shortDescription: String?
    let category: String?
    let unitPrice: Double?
    let squareThumbnailURL: String?
    let status: Int?
}

typealias HorizontalWelcome = [HorizontalWelcomeElement]
