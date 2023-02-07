//
//  ProfileVC.swift
//  CalorieFriend
//
//  Created by Daniel Bremner on 2/3/23.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet private var name: UITextField!
    @IBOutlet private var height: UITextField!
    @IBOutlet private var weight: UITextField!
    @IBOutlet private var age: UITextField!
    
    let defaults = UserDefaults.standard

    
    struct Keys {
        static let userAge = "userAge"
        static let userHeight = "userHeight"
        static let userName = "userName"
        static let userWeight = "userWeight"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkProfile()
    }

    
    @IBAction func saveButton(_ sender: UIButton) {
        saveProfile()
    }
    
    // Save any entered values
    func saveProfile() {
        defaults.set(name.text!, forKey: Keys.userName)
        defaults.set(height.text!, forKey: Keys.userHeight)
        defaults.set(weight.text!, forKey: Keys.userWeight)
        defaults.set(age.text!, forKey: Keys.userAge)
    }
    
    // Check if there are any saved values, if so update
    func checkProfile() {
        let savedName = defaults.value(forKey: Keys.userName) as? String ?? ""
        let savedAge = defaults.value(forKey: Keys.userAge) as? String ?? ""
        let savedHeight = defaults.value(forKey: Keys.userHeight) as? String ?? ""
        let savedWeight = defaults.value(forKey: Keys.userWeight) as? String ?? ""
        name.text = savedName
        age.text = savedAge
        height.text = savedHeight
        weight.text = savedWeight
    }
    
    // calculate Total Daily Expected Expenditure
    func calculateTDEE() -> Int {
        var tdee = 0
        
        let savedAge = defaults.value(forKey: Keys.userAge) as? String ?? ""
        let savedHeight = defaults.value(forKey: Keys.userHeight) as? String ?? ""
        let savedWeight = defaults.value(forKey: Keys.userWeight) as? String ?? ""
        
        if (savedAge != "" && savedHeight != "" && savedWeight != "") {
            let intWeight = Int(savedWeight) ?? 0
            let intHeight = Int(savedHeight) ?? 0
            let intAge = Int(savedAge) ?? 0
            let weightCalc = 10 * (Double(intWeight) / 2.205)
            let heightCalc = 6.25 * Double(intHeight) * 2.54
            let AgeCalc = 5 * Double(intAge) + 5
            tdee =  Int(weightCalc + heightCalc - AgeCalc)
            print(tdee)
        }
    //two formulas, 1 for female and 1 for male
    // (10 * weight (kg)) + (6.25 * height (cm)) - (5 * age)
    //                                  + 5 for males
    //                                  - 161 for females
        
        return Int(tdee)
    }

}
