//
//  FoodVC.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

class FoodVC: UITableViewController {
    
    let reuseIdentifier = "RecipeCell"
    var data: Response? {
        didSet {
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        let recipeManager = RecipeManager()
        
        recipeManager.fetchRecipes() { result in
            self.data = result
            DispatchQueue.main.async { [self] in
                navigationItem.title = "Menu"
            }
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .lightGray
        tableView.tableFooterView = UIView()
    }
    
}

extension FoodVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.to ?? 0) - (data?.from ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        guard let recipe = data?.hits?[indexPath.row].recipe else {
            return UITableViewCell()
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = "\(recipe.source!): \(recipe.label!) - \(round(recipe.calories!)) calories"
        
        return cell
    }
}
