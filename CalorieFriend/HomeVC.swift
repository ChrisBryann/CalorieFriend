//
//  HomeVC.swift
//  CalorieFriend
//
//  Created by Cole Perez on 2/15/23.
//

import UIKit
import Foundation
import SwiftUI
import Firebase
import HealthKit

class HomeVC: UIViewController {
    
    private let database = Database.database().reference()
    
       
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    @IBOutlet weak var consumedCaloriesLabel: UILabel!
    @IBOutlet weak var dailyPercentGoalLabel: UILabel!
    // add property to pass in HealthStore
    var healthStore: HealthStore?
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        typealias Model = (date: Date, views: Int)
        let data: [Model] = []
        return UIHostingController(coder: coder, rootView: Graph1(data: data))
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
        var currentCals = 0
        //let consumedCals = defaults.double(forKey: "currentCals")
        
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
        
        if (firstItemAdded && Calendar.current.isDateInYesterday(dateItemsAdded)) {
            defaults.removeObject(forKey: "totalRecipe")
            firstItemAdded = false
        }
        
        if (goalCals != "0"){
            // get total calories from current food list
            let totalRecipe = defaults.array(forKey: "totalRecipe") as? [[String: Any]]
            let dictEmpty: Bool = totalRecipe == nil
            if (!dictEmpty) {
                for data in totalRecipe! {
                    let cals: Int = data["Cals"] as? Int ?? 0
                    let count: Int = data["Count"] as? Int ?? 0
                    currentCals += (cals * count)
                }
            }
            
            defaults.set(currentCals, forKey: "currentCals")
            let consumedCaloriesInt = Int(currentCals)
            let goalCaloriesInt = Int(goalCals) ?? 1
            let score = ((Double(consumedCaloriesInt)/Double(goalCaloriesInt)) * 100)
            dailyPercentGoalLabel.text = String(Int(round(score))) + "%"
        }else{
            dailyPercentGoalLabel.text = "0%"
        }

        // TODO subtract calories burned
        goalCaloriesLabel.text = goalCals
        let burnedCals: Int = defaults.value(forKey: "CaloriesBurnedDate") as? Int ?? 0
        consumedCaloriesLabel.text = String(currentCals - burnedCals)
        
        addToDatabse(goalCalories: goalCals, consumedCalories: String(currentCals - burnedCals))
            
    }
    
    private func addToDatabse(goalCalories: String, consumedCalories: String) -> Void {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let todayStr = df.string(from: Date())
        
        let entry: [String: Any] = [
            "Goal": goalCalories as NSObject,
            "Calories": consumedCalories
        ]
        database.child(todayStr).setValue(entry)
    }
    private func getLastSevenDays() ->[String] {
        var dates: [String] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        for i in -7 ... -1{
            dates.append(df.string(from: Calendar.current.date(byAdding: .day, value: i, to: Date())!))
        }
        return dates;

    }
    public func getFromDatabse() async throws -> [(String, Int)] {
        var scoresForLastSeven: [(String, Int)] = []
        let dates: [String] = getLastSevenDays()
        for date in dates {
            let data = try await database.child(date).getData();
            if let value = data.value as? [String: Any] {
                let caloriesConsumedStr = value["Calories"] as! String
                let goalStr = value["Goal"] as! String
                if caloriesConsumedStr == "0" || goalStr == "0"{
                    scoresForLastSeven.append((date,0));
                    continue;
                }
                let caloriesConsumedDouble = Double(caloriesConsumedStr) ?? 0.0
                let goalDouble = Double(goalStr) ?? 1.0
                let score = Int(round(caloriesConsumedDouble/goalDouble * 100))
                print(date, caloriesConsumedDouble, goalDouble, score)

                scoresForLastSeven.append((date, score))
            } else {
                continue;
            }
        }
        return scoresForLastSeven
    }
    typealias Model = (date: String, views: Int)
    public func getFromDatabse() async throws -> [Model] {
        var scoresForLastSeven: [Model] = []
        let dates: [String] = getLastSevenDays()
        for date in dates {
            let data = try await database.child(date).getData();
            if let value = data.value as? [String: Any] {
                let caloriesConsumedStr = value["Calories"] as! String
                let goalStr = value["Goal"] as! String
                if caloriesConsumedStr == "0" || goalStr == "0"{
                    scoresForLastSeven.append((date,0));
                    continue;
                }
                let caloriesConsumedDouble = Double(caloriesConsumedStr) ?? 0.0
                let goalDouble = Double(goalStr) ?? 1.0
                let score = Int(round(caloriesConsumedDouble/goalDouble * 100))
                print(date, caloriesConsumedDouble, goalDouble, score)

                scoresForLastSeven.append((date, score))
            } else {
                continue;
            }
        }
        return scoresForLastSeven
    }
}

