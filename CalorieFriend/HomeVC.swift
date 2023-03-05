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
    // add property to pass in HealthStore
    var healthStore: HealthStore?
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: Graph1())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthStore = HealthStore()
    }
    // TODO TELL USERS TO ADD GOALS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        let goalCals = defaults.string(forKey: "userTDEE") ?? "0"
        let consumedCals = defaults.double(forKey: "currentCals")
        
        if (goalCals != "0"){
            let consumedCaloriesInt = Int(consumedCals)
            let goalCaloriesInt = Int(goalCals) ?? 1
            let score = ((Double(consumedCaloriesInt)/Double(goalCaloriesInt)) * 100)
            dailyPercentGoalLabel.text = String(Int(round(score))) + "%"
        }else{
            dailyPercentGoalLabel.text = "0%"
        }
        // get calories burned - bryan
        if let healthStore = healthStore {
            healthStore.getCaloriesBurned(startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, endDate: Date(), asc: false, completion: { success in
                if success == "ERROR" {
                    print("cannot retrieve calories! please enable healthkit permission!")
                }else if success == "SAMPLE_ERR" {
                    print("sample error!")
                }else if success == "NO_SAMPLE" {
                    print("no data available!")
                }else {
                    print("got calories!")
                }
            })
        }
        // TODO subtract calories burned
        goalCaloriesLabel.text = goalCals
        consumedCaloriesLabel.text = String(Int(round(consumedCals)))
    }
}

