//
//  SignUpVC.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 28/01/23.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let userName = name.text else { return }
        guard let userEmail = email.text else { return }
        guard let userPassword = password.text else { return }
        guard let userConfirmPassword = confirmPassword.text else { return }
        // TODO: Email, Password Confirmation VALIDATION
        
        // if everything is valid, then we create account
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { firebaseResult, err in
            if let e = err { //if an error exists
                print("error")
            } else{
                // Go to home page
                self.performSegue(withIdentifier: "signUpToHome", sender: self)
            }
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
