//
//  SignUpVC.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 28/01/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpVC: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    private var healthStore: HealthStore?
    
    let database = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        healthStore = HealthStore()

        // Do any additional setup after loading the view.
        let docRef = database.document("CalorieFriend/users")
        docRef.getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            print(data)
        }
    }
    @IBAction func enableHealthKitClicked(_ sender: UIButton) {
        if let healthStore = healthStore {
            print("good")
            healthStore.requestAuthorization(completion: { success in
                print("authorized")
            })
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        let docRef = database.document("CalorieFriend/users")
        guard let userName = name.text else { return }
        guard let userEmail = email.text else { return }
        guard let userPassword = password.text else { return }
        guard let userConfirmPassword = confirmPassword.text else { return }
        // TODO: Email, Password Confirmation VALIDATION
        
        // if everything is valid, then we create account and save account information in firestore
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { firebaseResult, err in
            if let _ = err { //if an error exists
                print("error")
            } else{
                // create a new user instance in firestore database
                docRef.setData([
                    userEmail : [
                        "username": userName
                    ]
                ], merge: true)
                // Go to home page
                self.performSegue(withIdentifier: "signUpToHome", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToHome" {
            guard let destVC = segue.destination as? HomeVC else { return }
            destVC.healthStore = healthStore
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
