//
//  Basket.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import Foundation

struct Basket {
    var verticalProduct : [VerticalProduct]?
    var horizontalProduct : [HorizontalProduct]?
    
    init(verticalProduct: [VerticalProduct]? = [], 
         horizontalProduct: [HorizontalProduct]? = []) {
        
        self.verticalProduct = verticalProduct
        self.horizontalProduct = horizontalProduct
    }
}
