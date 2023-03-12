//
//  ProfileView.swift
//  CalorieFriend
//
//  Created by Daniel Bremner on 3/11/23.
//

import SwiftUI
import Firebase
import Combine

struct Keys {
    static let userAge = "userAge"
    static let userBirthDate = "userBirthDate"
    static let userHeight = "userHeight"
    static let userName = "userName"
    static let userWeight = "userWeight"
    static let userSex = "userSex"
    static let userGoal = "userGoal"
}

let defaults = UserDefaults.standard


struct ProfileView: View {
    @State private var healthStore: HealthStore?
    
    @State var fullName = ""
    @State var weight = ""
    @State var height = ""
    @State var sex = ""
    @State var goal = ""
    @State private var birthdate = Date()

    // Build Form for profile entry
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextInputField("Full name", text: $fullName)
                    
                    TextInputField("Height (inches)", text: $height)
                        .keyboardType(.numberPad)
                        .onReceive(Just(weight)) { newValue in
                            let filtered = newValue.filter {"0123456789".contains($0)}
                            if filtered != newValue {
                                self.weight = filtered
                            }
                            
                        }
                    
                    TextInputField("Weight (pounds)", text: $weight)
                        .keyboardType(.numberPad)
                        .onReceive(Just(weight)) { newValue in
                            let filtered = newValue.filter {"0123456789".contains($0)}
                            if filtered != newValue {
                                self.weight = filtered
                            }
                            
                        }
                    
                    DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                    
                    Picker("Sex", selection: $sex) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                }
                
                Section(header: Text("Set Health Goal")) {
                    Picker("Goal", selection: $goal) {
                        Text("Maintain Current Weight (+0 kCals)").tag("Maintain Current Weight (+0 kCals)")
                        Text("Gain Weight (+500 kCals)").tag("Gain Weight (+500 kCals)")
                        Text("Lose Weight (-500 kCals)").tag("Lose Weight (-500 kCals)")
                    }
                }
                
                Section() {
                    Button("Enable Healthkit") {
                        if let healthStore = healthStore {
                            print("good")
                            healthStore.requestAuthorization(completion: { success in
                                print("authorized")
                            })
                        }
                    }
                }
                
                Section() {
                    // button save profile stores userdefaults
                    Button("Save Profile") {
                        defaults.set(fullName, forKey: Keys.userName)
                        defaults.set(weight, forKey: Keys.userWeight)
                        defaults.set(height, forKey: Keys.userHeight)
                        defaults.set(birthdate, forKey: Keys.userBirthDate)
                        defaults.set(sex, forKey: Keys.userSex)
                        defaults.set(goal, forKey: Keys.userGoal)
                        let now = Date()
                        let calendar = Calendar.current
                        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
                        defaults.set(ageComponents.year!, forKey: Keys.userAge)
                    }
                }
                
                Section() {
                    Button("Logout") {
                        /*
                        do {
                            try Auth.auth().signOut()
                            self.performSegue(withIdentifier: "ProfileToLogin", sender: self)
                        } catch let logoutError as NSError {
                            print("Error logging out: \(logoutError)")
                        }*/
                    }
                }
            }
            .navigationTitle("Profile")
            // when loaded restore from user defaults
            .onAppear {
                healthStore = HealthStore()
                fullName = defaults.value(forKey: Keys.userName) as? String ?? ""
                weight = defaults.value(forKey: Keys.userWeight) as? String ?? ""
                height = defaults.value(forKey: Keys.userHeight) as? String ?? ""
                birthdate = defaults.value(forKey: Keys.userBirthDate) as? Date ?? Date()
                sex = defaults.value(forKey: Keys.userSex) as? String ?? ""
                goal = defaults.value(forKey: Keys.userGoal) as? String ?? ""
                
            }
        }
    }
}

// Modify TextFields to show title when text is displayed
struct TextInputField: View {
    var title: String
    @Binding var text: String
    init(_ title:String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.isEmpty ? 0 :-25)
                .scaleEffect(text.isEmpty ? 1: 0.8, anchor: .leading)
            TextField("", text: $text)
        }
        .padding(.top, 15)
    }
    
}

func calculateTDEE() -> Int {
    var tdee = 0
    
    let savedAge = defaults.value(forKey: Keys.userAge) as? String ?? ""
    let savedHeight = defaults.value(forKey: Keys.userHeight) as? String ?? ""
    let savedWeight = defaults.value(forKey: Keys.userWeight) as? String ?? ""
    let savedSex = defaults.value(forKey: Keys.userSex) as? String ?? ""
    let savedGoal = defaults.value(forKey: Keys.userGoal) as? String ?? ""
    
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
}



