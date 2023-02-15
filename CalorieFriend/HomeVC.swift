//
//  HomeVC.swift
//  CalorieFriend
//
//  Created by Cole Perez on 2/15/23.
//

import UIKit
import Foundation
import SwiftUI

class HomeVC: UIViewController {
    
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    @IBOutlet weak var consumedCaloriesLabel: UILabel!
    @IBOutlet weak var dailyPercentGoalLabel: UILabel!
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: Graph1())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    // TODO TELL USERS TO ADD GOALS
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let goalCals = defaults.string(forKey: "userGoal") ?? "0"
        let consumedCals = "1000"
        
        if (goalCals != "0"){
            let consumedCaloriesInt = Int(consumedCals) ?? 1
            let goalCaloriesInt = Int(goalCals) ?? 1
            let score = ((Double(consumedCaloriesInt)/Double(goalCaloriesInt)) * 100)
            dailyPercentGoalLabel.text = String(Int(round(score))) + "%"
        }else{
            dailyPercentGoalLabel.text = "0%"
        }
        goalCaloriesLabel.text = goalCals
        consumedCaloriesLabel.text = consumedCals
    }
}

