//
//  ProductsService.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import Foundation
import Alamofire

protocol ProductsServiceProtocol {
    func getHorizontalItems(url: URL, completion: @escaping ([HorizontalWelcomeElement]?) -> ())
    
    func getVerticalItems(url: URL, completion: @escaping ([VerticalWelcomeElement]?) -> ())
}

final class ProductsService: ProductsServiceProtocol {
    
    func getHorizontalItems (url : URL , completion : @escaping ([HorizontalWelcomeElement]?) -> () ){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }else if let data = data {
                
                let data = try? JSONDecoder().decode([HorizontalWelcomeElement].self, from: data)
                
                if let data = data {
                    completion(data)
                }
                
            }
        }.resume()
    }
    
    func getVerticalItems (url : URL , completion : @escaping ([VerticalWelcomeElement]?) -> () ){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }else if let data = data {
                let data = try? JSONDecoder().decode([VerticalWelcomeElement].self, from: data)
                if let data = data {
                    completion(data)
                }
                
            }
        }.resume()
    }
}
