//
//  FoodResultVC.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 07/03/23.
//

import UIKit

class FoodResultVC: UIViewController {

    @IBOutlet var searchButton: UIButton!
    
    var tableView = UITableView()
    
    var recipes: [[String: Any]] = []
    
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = "Food List"
        recipes = fetchData()
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont(name: "Futura", size: 36)!
        ]
    }
    // everytime this page appears, refresh the food result to show the added foods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipes = fetchData()
        tableView.reloadData()
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        // set delegates
        setTableViewDelegates()
        // set row height
        tableView.rowHeight = 60
        // register cells
        tableView.register(FoodResultLabel.self, forCellReuseIdentifier: "FoodResultLabel")
        // set constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FoodResultToFoodSearch", sender: self)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension FoodResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // how many cells?
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodResultLabel") as! FoodResultLabel
        let recipe = recipes[indexPath.row]
        cell.set(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipes.remove(at: indexPath.row)
            removeData(recipe: recipe)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}

extension FoodResultVC {
    func fetchData() -> [[String: Any]] {
        if let totalRecipe = defaults.array(forKey: "totalRecipe") as? [[String:Any]] {
            return totalRecipe
        }else{
            return []
        }
    }
    
    func removeData(recipe: [String: Any]) -> Void {
        if let totalRecipe = defaults.array(forKey: "totalRecipe") as? [[String:Any]] {
            let newTotalRecipe = totalRecipe.filter { data in
                data["Label"] as! String != recipe["Label"] as! String
            }
            self.defaults.set(newTotalRecipe, forKey: "totalRecipe")
        }
    }
}
