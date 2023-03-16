//
//  FoodModel.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

struct RecipeManager {
    
    func fetchRecipes(searchText: String, parameters: String, completion: @escaping (Response) -> Void) {
        let app_id = "924797ad"
        let app_key = "1c303b7a13757ae604f986bd6cb5ddba"
        let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=\(searchText)&app_id=\(app_id)&app_key=\(app_key)\(parameters)")
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error fetching API: \(error)")
            }
            
            if data != nil && error == nil {
                do {
                    let jsonData = try JSONDecoder().decode(Response.self, from: data!)
                    completion(jsonData)
                }
                catch {
                    print("Error decoding JSON \(error)")
                }
            }
        }
        dataTask.resume()
    }
}

struct Response: Decodable {
    var from: Int?
    var to: Int?
    var count: Int?
    var _links: Links?
    var hits: [Hit]?
}

struct Links: Decodable {
    var `self`: Link?
    var next: Link?
}

struct Link: Decodable {
    var href: String?
    var title: String?
}

struct Hit: Decodable {
    var recipe: Recipe?
    var _links: Links?
}

struct Recipe: Decodable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories: Double?
    var glycemicIndex: Double?
    var totalWeight: Double?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String]?
    var instructions: [String]?
    var tags: [String]?
//    var totalNutrients: NutrientsInfo
//    var totalDaily: NutrientsInfo
//    var digest: Digest
}

struct Images: Decodable {
    var thumbnail: ImageInfo?
    var small: ImageInfo?
    var regular: ImageInfo?
    var large: ImageInfo?
}

struct ImageInfo: Decodable {
    var url: String?
    var width: Int?
    var height: Int?
}

struct Ingredient: Decodable {
    var text: String?
    var quantity: Double?
    var measure: String?
    var food: String?
    var weight: Double?
    var foodID: String?
}

struct Nutrient: Decodable {
    var label: String?
    var quantity: Double?
    var unit: String?
}
