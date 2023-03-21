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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let goalCals = defaults.string(forKey: "userTDEE") ?? "0"
        var currentCals = 0
        
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
        
        let today = Date()
        let dateItemsAdded = defaults.value(forKey: "dateFirstAdded") as? Date ?? Date()
        let firstItemAdded: Bool = defaults.value(forKey: "firstItemAdded") as? Bool ?? false
        let sameDay: Bool = Calendar.current.isDate(today, inSameDayAs: dateItemsAdded)
        
        print("date items added: ")
        print(dateItemsAdded)
        print("today")
        print(today)
        print(firstItemAdded)
        
        if (firstItemAdded && !sameDay) {
            defaults.removeObject(forKey: "totalRecipe")
            defaults.set(false, forKey: "firstItemAdded")
        }
        
        var burnedCals = 0
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
            
            // get todays burned calories
            let date = Date()
            
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let todayStr = df.string(from: date)
            
            let burnedCalsData = defaults.array(forKey: "CaloriesBurnedData") as? [[String: Any]]
            
            let dictIsEmpty: Bool = burnedCalsData == nil
            if (!dictIsEmpty){
                for data in burnedCalsData! {
                    let fullDate = data["date"] as? String ?? ""
                    if todayStr == fullDate.split(separator: " ")[0] {
                        burnedCals += data["calories"] as? Int ?? 0
                    }
                }
            }
            
            print("burnedCals")
            print(burnedCals)
            
            defaults.set((currentCals - burnedCals), forKey: "currentCals")
            let caloriesInt = Int(currentCals - burnedCals)
            let goalCaloriesInt = Int(goalCals) ?? 1
            var score = 0.0
            if (caloriesInt > goalCaloriesInt) {
                score = ((Double(goalCaloriesInt)/Double(caloriesInt)) * 100.0)
                dailyPercentGoalLabel.text = String(Int(round(score))) + "%"
                switch score as Double {
                case 0.0..<60.0:
                    dailyPercentGoalLabel.textColor = .systemRed
                case 60.0..<80.0:
                    dailyPercentGoalLabel.textColor = .systemOrange
                case 80.0..<100:
                    dailyPercentGoalLabel.textColor = .systemYellow
                default:
                    dailyPercentGoalLabel.textColor = .label
                }
                
                
            } else {
                score = ((Double(caloriesInt)/Double(goalCaloriesInt)) * 100.0)
                if (score < 0.0) {
                    dailyPercentGoalLabel.text = "0%"
                    dailyPercentGoalLabel.textColor = .label
                } else {
                    dailyPercentGoalLabel.text = String(Int(round(score))) + "%"
                    dailyPercentGoalLabel.textColor = .systemGreen
                }
            }
            
            
        }else{
            dailyPercentGoalLabel.text = "0%"
            dailyPercentGoalLabel.textColor = .label
        }
        
        goalCaloriesLabel.text = goalCals
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

