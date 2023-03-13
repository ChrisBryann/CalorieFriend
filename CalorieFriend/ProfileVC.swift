//
//  ProfileVC.swift
//  CalorieFriend
//
//  Created by Daniel Bremner on 2/3/23.
//

import UIKit
import SwiftUI
import Firebase

class ProfileVC: UIViewController {
    
    var profileView: UIHostingController<ProfileView>!
    
    private var healthStore: HealthStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = UIHostingController(rootView: ProfileView(dismissedAction: {self.performSegue(withIdentifier: "ProfileToLogin", sender: self)}))
        addChild(profileView)
        view.addSubview(profileView.view)
        profileView.didMove(toParent: self)
        setupConstraints()
        healthStore = HealthStore()
    }
    
    func setupConstraints() {
        profileView.view.translatesAutoresizingMaskIntoConstraints = false
        profileView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        profileView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
