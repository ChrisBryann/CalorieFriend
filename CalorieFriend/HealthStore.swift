//
//  HealthStore.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 31/01/23.
//

import Foundation
import HealthKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    var dateFormatter: DateFormatter
    
    init(){
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let steps = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let distanceWalked = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let walkingSpeed = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let activeEnergyBurned = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        guard let healthStore = self.healthStore else { return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [steps, distanceWalked, walkingSpeed, activeEnergyBurned]) { success, error in
            completion(success)
        }
        
    }
    ///
    /// gets user's calories burned amount and save it to user's defaults.
    ///
    func getCaloriesBurned(startDate: Date, endDate: Date, asc: Bool, completion: @escaping (String) -> Void) -> Void{
        let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: asc)
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]){ query, results, error in
            if let _ = error {
                completion("ERROR")
                return
            }
            guard let samples = results as? [HKQuantitySample] else {
                completion("SAMPLE_ERR")
                return
            }
            if samples.isEmpty {
                completion("NO_SAMPLE")
                return
            }
            for sample in samples{
                let unit = HKUnit(from: "Cal")
                let calories = sample.quantity.doubleValue(for: unit)
                print("calories: \(calories)")
                let date = self.dateFormatter.string(from:sample.startDate)
                print("date: \(date)")
                print("")
            }
        }
        healthStore!.execute(query)
        completion("")
    }
}
