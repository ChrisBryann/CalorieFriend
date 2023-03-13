//
//  LoginVC.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 28/01/23.
//

import UIKit
import Firebase
import SwiftUI

class LoginVC: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var invalidCredentials: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        invalidCredentials.isHidden = true
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let userEmail = email.text else { return }
        guard let userPassword = password.text else { return }
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { firebaseResult, err in
            if let _ = err {
                self.invalidCredentials.isHidden = false
                self.email.text = ""
                self.password.text = ""
            } else {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
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

//struct LoginVCWrapper: UIViewControllerRepresentable {
//    typealias UIViewControllerType = LoginVC
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCWrapper>) -> LoginVCWrapper.UIViewControllerType {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginViewController: LoginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        
//        return loginViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: LoginVCWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCWrapper>) {
//        //
//    }
//}
