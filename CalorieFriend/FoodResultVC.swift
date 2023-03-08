//
//  FoodResultVC.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 07/03/23.
//

import UIKit

class FoodResultVC: UIViewController {

    @IBOutlet var searchButton: UIButton!
    @IBOutlet var foodStackView: UIStackView!
    
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Foods"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!]
    }
    // everytime this page appears, refresh the food result to show the added foods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear")
        if let addedRecipe = defaults.array(forKey: "addedRecipe") as? [[String:Any]] {
            for recipe in addedRecipe {
                let label = UILabel()
                label.text = "Food: \(recipe["Label"] as? String ?? ""), Cals: \(recipe["Cals"] as? Double ?? 0)"
                foodStackView.addArrangedSubview(label) // this infinitely adds new label everytime we load. NEED TO FIX: everytime it loads, delete all subviews and add again the updated data.
            }
            // once finish adding the labels, reset the addedRecipe userDefaults
            self.defaults.set(nil, forKey: "addedRecipe")
        }
        
    }
    
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FoodResultToFoodSearch", sender: self)
    }
    
}
