//
//  ProfileVC.swift
//  CalorieFriend
//
//  Created by Daniel Bremner on 2/3/23.
//

import UIKit
import SwiftUI
import Firebase

class ProfileVC: UIViewController {
    
    let profileView = UIHostingController(rootView: ProfileView())
    private var healthStore: HealthStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(profileView)
        view.addSubview(profileView.view)
        setupConstraints()
        healthStore = HealthStore()
    }
    
    func setupConstraints() {
        profileView.view.translatesAutoresizingMaskIntoConstraints = false
        profileView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        profileView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    /*
    @IBOutlet private var name: UITextField!
    @IBOutlet private var height: UITextField!
    @IBOutlet private var weight: UITextField!
    @IBOutlet private var age: UITextField!
    @IBOutlet private var sexSelectButton: UIButton!
    @IBOutlet private var goalSelectButton: UIButton!
    private var healthStore: HealthStore?
    
    let defaults = UserDefaults.standard

    struct Keys {
        static let userAge = "userAge"
        static let userHeight = "userHeight"
        static let userName = "userName"
        static let userWeight = "userWeight"
        static let userSex = "userSex"
        static let userGoal = "userGoal"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthStore = HealthStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkProfile()
    }
    
    // sets up display of popup button with userDefault saved userGoal
    func setGoalButton(selected: String) {
        let setAction = {(action : UIAction) in print(action.title)}
        
        switch selected {
        case "Maintain Current Weight (+0 kCals)":
            goalSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", handler: setAction),
                UIAction(title: "Maintain Current Weight (+0 kCals)", state : .on, handler: setAction),
                UIAction(title: "Gain Weight (+500 kCals)", handler: setAction),
                UIAction(title: "Lose Weight (-500 kCals)", handler: setAction)])
        case "Gain Weight (+500 kCals)":
            goalSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", handler: setAction),
                UIAction(title: "Maintain Current Weight (+0 kCals)", handler: setAction),
                UIAction(title: "Gain Weight (+500 kCals)", state : .on, handler: setAction),
                UIAction(title: "Lose Weight (-500 kCals)", handler: setAction)])
        case "Lose Weight (-500 kCals)":
            goalSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", handler: setAction),
                UIAction(title: "Maintain Current Weight (+0 kCals)", handler: setAction),
                UIAction(title: "Gain Weight (+500 kCals)", handler: setAction),
                UIAction(title: "Lose Weight (-500 kCals)", state : .on, handler: setAction)])
        default:
            goalSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", state : .on, handler: setAction),
                UIAction(title: "Maintain Current Weight (+0 kCals)", handler: setAction),
                UIAction(title: "Gain Weight (+500 kCals)", handler: setAction),
                UIAction(title: "Lose Weight (-500 kCals)", handler: setAction)])
        }
        
        goalSelectButton.showsMenuAsPrimaryAction = true
        goalSelectButton.changesSelectionAsPrimaryAction = true
    }
    
    // sets up display of popup button with userDefault saved userSex
    func setSexButton(selected: String) {
        let setAction = {(action : UIAction) in print(action.title)}
        
        switch selected {
        case "Male":
            sexSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", handler:  setAction),
                UIAction(title: "Male",state : .on, handler:  setAction),
                UIAction(title: "Female", handler:  setAction)])
        case "Female":
            sexSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select", handler:  setAction),
                UIAction(title: "Male", handler:  setAction),
                UIAction(title: "Female",state : .on, handler:  setAction)])
        default:
            sexSelectButton.menu = UIMenu(children : [
                UIAction(title: "Select",state : .on, handler:  setAction),
                UIAction(title: "Male", handler:  setAction),
                UIAction(title: "Female", handler:  setAction)])
        }
        
        sexSelectButton.showsMenuAsPrimaryAction = true
        sexSelectButton.changesSelectionAsPrimaryAction = true
    }
    @IBAction func enableHealthKit(_ sender: UIButton) {
        if let healthStore = healthStore {
            print("good")
            healthStore.requestAuthorization(completion: { success in
                print("authorized")
            })
        }
    }
    @IBAction func logoutClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "ProfileToLogin", sender: self)
        } catch let logoutError as NSError {
            print("Error logging out: \(logoutError)")
        }
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
        defaults.set(sexSelectButton.currentTitle, forKey: Keys.userSex)
        defaults.set(goalSelectButton.currentTitle, forKey: Keys.userGoal)
        defaults.set(String(calculateTDEE()), forKey: "userTDEE")
    }
    
    // Check if there are any saved values, if so update
    func checkProfile() {
        let savedName = defaults.value(forKey: Keys.userName) as? String ?? ""
        let savedAge = defaults.value(forKey: Keys.userAge) as? String ?? ""
        let savedHeight = defaults.value(forKey: Keys.userHeight) as? String ?? ""
        let savedWeight = defaults.value(forKey: Keys.userWeight) as? String ?? ""
        let savedSex = defaults.value(forKey: Keys.userSex) as? String ?? "Select"
        let savedGoal = defaults.value(forKey: Keys.userGoal) as? String ?? "Select"
        
        setSexButton(selected: savedSex)
        setGoalButton(selected: savedGoal)
        
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
        let savedSex = defaults.value(forKey: Keys.userSex) as? String ?? "Select"
        let savedGoal = defaults.value(forKey: Keys.userGoal) as? String ?? "Select"
        
        if (savedAge != "" && savedHeight != "" && savedWeight != "") {
            let intWeight = Int(savedWeight) ?? 0
            let intHeight = Int(savedHeight) ?? 0
            let intAge = Int(savedAge) ?? 0
            let weightCalc = 10 * (Double(intWeight) / 2.205)
            let heightCalc = 6.25 * Double(intHeight) * 2.54
            let AgeCalc = 5 * Double(intAge) + 5
            
            tdee =  Int(weightCalc + heightCalc - AgeCalc)
            
            if (savedSex == "Male") {
                tdee += 5
            } else if (savedSex == "Female") {
                tdee -= 161
            }
            
            if (savedGoal == "Gain Weight (+500 kCals)") {
                tdee += 500
            } else if (savedGoal == "Lose Weight (-500 kCals)") {
                tdee -= 500
            }
        }
        
        return Int(tdee)
    }*/
}
