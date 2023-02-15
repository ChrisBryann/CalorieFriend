//
//  HomeVC.swift
//  CalorieFriend
//
//  Created by Cole Perez on 2/15/23.
//

import UIKit
import Foundation
import SwiftUI

class HomeVC: UIViewController {
    
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: Graph1())
    }
}

