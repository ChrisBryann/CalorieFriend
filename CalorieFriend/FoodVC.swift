//
//  FoodVC.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

class FoodVC: UITableViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
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
    
    func getParameters() -> String {
        var parameters = ""
        
        let defaults = UserDefaults.standard
        let goalCals = calculateTDEE()
        let burnedCalsData = defaults.array(forKey: "CaloriesBurnedData") as? [[String: Any]]
        var burnedCals = 0
        let consumedRecipes = defaults.array(forKey: "totalRecipe") as? [[String: Any]]
        var consumedCals = 0
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let todayStr = df.string(from: date)
        
        let dictEmpty: Bool = consumedRecipes == nil
        if (!dictEmpty) {
            for data in consumedRecipes! {
                let cals: Int = data["Cals"] as? Int ?? 0
                let count: Int = data["Count"] as? Int ?? 0
                consumedCals += (cals * count)
            }
        }
        
        let dictIsEmpty: Bool = burnedCalsData == nil
        if (!dictIsEmpty){
            for data in burnedCalsData! {
                let fullDate = data["date"] as? String ?? ""
                if todayStr == fullDate.split(separator: " ")[0] {
                    burnedCals += data["calories"] as? Int ?? 0
                }
            }
        }
        
        if (consumedCals - burnedCals) > goalCals {
            let alert = UIAlertController(title: "Calorie Limit Exceeded", message: "You have exceeded your calorie intake for the day. Consider having a lower calorie meal or burning calories with exercise!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        var recommendedCals = 0;
        let numConsumed = consumedRecipes?.count ?? 0
        if (numConsumed >= 3) {
            recommendedCals = ((goalCals + burnedCals - consumedCals))
        } else {
            recommendedCals = ((goalCals + burnedCals - consumedCals) / (3 - numConsumed))
        }
        
        switch recommendedCals {
        case 200...:
            parameters += "&calories=\(recommendedCals - 200)-\(recommendedCals + 200)"
        default:
            parameters += ""
        }
        
        switch hour as Int {
        case 4..<10:
            parameters += "&mealType=Breakfast"
        case 10..<16:
            parameters += "&mealType=Lunch"
        case 16..<22:
            parameters += "&mealType=Dinner"
        default:
            parameters += ""
        }
        
        return parameters
    }
    
    func search() {
        let recipeManager = RecipeManager()
        let text = searchBar.text ?? ""
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        let parameters = getParameters()
        
        if (searchText != ""){
            recipeManager.fetchRecipes(searchText: searchText, parameters: parameters) { result in
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
        let defaults = UserDefaults.standard
        let firstItemAdded = defaults.value(forKey: "firstItemAdded") as? Bool ?? false
        
        if (!firstItemAdded) {
            defaults.set(true, forKey: "firstItemAdded")
            defaults.set(Date(), forKey: "dateFirstAdded")
        }
        
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
        let alert = UIAlertController(title: "Recipe Added!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapRecipeLinkButton(with recipe: Recipe) {
        guard let url = URL(string: recipe.url!) else { return }
        UIApplication.shared.open(url)
    }
}
