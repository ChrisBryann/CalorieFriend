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
    
    init(){
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
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
    func getCaloriesBurned(startDate: Date, endDate: Date, asc: Bool, completion: @escaping (Bool) -> Void) -> Void{
        let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: asc)
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]){ query, results, error in
            if let _ = error {
                completion(false)
                return
            }
            guard let samples = results as? [HKQuantitySample] else {
                completion(false)
                return
            }
            for sample in samples{
                print(sample)
            }
        }
        healthStore!.execute(query)
    }
}
