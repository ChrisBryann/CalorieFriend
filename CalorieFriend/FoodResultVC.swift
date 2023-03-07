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
    }
    // everytime this page appears, refresh the food result to show the added foods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("in food result appear!")
        self.defaults.string(forKey: "") // get the added food results
        let label = UILabel()
        label.text = "Testing!"
        foodStackView.addArrangedSubview(label) // this infinitely adds new label everytime we load. NEED TO FIX: everytime it loads, delete all subviews and add again the updated data.
    }
    
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FoodResultToFoodSearch", sender: self)
    }
    
}
