//
//  FoodVC.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

public var dateItemsAdded: Date = Date()
public var firstItemAdded: Bool = false

class FoodVC: UITableViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        print("BUTTON CLICKED");
        search();
    }
    
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
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .lightGray
        tableView.register(RecipeCell.nib(), forCellReuseIdentifier: RecipeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
//        navigationItem.title = "Recipes"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.to ?? 0) - (data?.from ?? 0)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier,
                                                 for: indexPath) as! RecipeCell
        
        guard let recipe = data?.hits?[indexPath.row].recipe else {
            return UITableViewCell()
        }
        
        cell.configure(with: recipe)
        cell.delegate = self
        
        return cell
    }
    
    func getCalories() -> String {
        let defaults = UserDefaults.standard
        let goal = defaults.value(forKey: "userGoal")
        
        switch goal as? String {
        case "Gain Weight (+500 kCals)":
            return "&calories=500-700"
        case "Maintain Current Weight (+0 kCals)":
            return "&calories=300-500"
        case "Lose Weight (-500 kCals)":
            return "&calories=100-300"
        default:
            return ""
        }
    }
    
    func search() {
        let recipeManager = RecipeManager()
        let searchText = searchBar.text ?? nil
        let calories = getCalories()
        print(searchText ?? "EDIDI")
        
        if (searchText != nil){
            recipeManager.fetchRecipes(searchText: searchText!, calories: calories) { result in
                self.data = result
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            }
        }
    }
}

extension FoodVC: RecipeCellDelegate {
    func didTapAddRecipeButton(with recipe: Recipe) {
        
        if (!firstItemAdded) {
            firstItemAdded = true
            dateItemsAdded = Date()
        }
        
        let defaults = UserDefaults.standard
        print("\(recipe.source ?? "1")")
        print("\(recipe.calories ?? 0)")
        let recipeCalories : Double = recipe.calories ?? 0
        let recipeYield : Double = recipe.yield ?? 0
        
        let data = [
            "Label": recipe.label!,
            "Cals": Int(recipeCalories / recipeYield),
            "URL": recipe.url!,
            "Count": 1,
        ] as [String : Any]
        
        var totalRecipe : [[String: Any]] = []
        if let totalData = defaults.array(forKey: "totalRecipe") as? [[String: Any]] {
            totalRecipe = totalData
        }
        
        if let idx = totalRecipe.firstIndex(where: {$0["Label"] as! String == data["Label"] as! String}) {
            print("found!")
            var dict = totalRecipe[idx] as [String: Any]
            dict.updateValue(dict["Count"] as! Int + 1, forKey: "Count")
            totalRecipe[idx] = dict
             // if it already exists, update the count!
        }else {
            totalRecipe.append(data)
        }
    
        defaults.set(totalRecipe, forKey: "totalRecipe")
    }
    
    func didTapRecipeLinkButton(with recipe: Recipe) {
        print("tapped recipe link")
        guard let url = URL(string: recipe.url!) else { return }
        UIApplication.shared.open(url)
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "currentCals") // temp way to set current calories back to 0, remove later
    }
}
