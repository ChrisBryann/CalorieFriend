//
//  FoodModel.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

struct ToDoManager {
    
    func fetchToDos(completion: @escaping ([ToDo]) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error fetching API: \(error)")
            }
            
            if data != nil && error == nil {
                do {
                    let jsonData = try JSONDecoder().decode([ToDo].self, from: data!)
                    completion(jsonData)
                }
                catch {
                    print("Error decoding JSON")
                }
            }
        }
        dataTask.resume()
    }
}

struct ToDo: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
