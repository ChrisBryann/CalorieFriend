//
//  FoodVC.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

class FoodVC: UITableViewController {
    //@IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        print("BUTTON CLICKEDF");
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
    func search(){
        let recipeManager = RecipeManager()
        let searchText = searchBar.text ?? nil
        print(searchText ?? "EDIDI")
        if ((searchText) != nil){
            recipeManager.fetchRecipes(searchText: searchText!) { result in
                self.data = result
                DispatchQueue.main.async { [self] in
                    navigationItem.title = "Menu"
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension FoodVC: RecipeCellDelegate {
    func didTapAddRecipeButton(with recipe: Recipe) {
        let defaults = UserDefaults.standard
        let consumedCals = defaults.double(forKey: "currentCals")
        print("\(recipe.source ?? "1")")
        print("\(recipe.calories ?? 0)")
        let newCalories = (recipe.calories ?? 0) + consumedCals
        print("\(newCalories)")
        defaults.set(newCalories, forKey: "currentCals")
        //defaults.set(0, forKey: "currentCals")
    }
}
