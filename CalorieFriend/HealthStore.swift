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
}
