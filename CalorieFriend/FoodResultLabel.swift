//
//  FoodResultLabel.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 08/03/23.
//

import UIKit

class FoodResultLabel: UITableViewCell {
    
    var foodLabel = UILabel()
    var foodCountLabel = UILabel()
    
    var data: [String:Any] = [:]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(foodLabel)
        addSubview(foodCountLabel)
        
        configureFoodCountLabel()
        configureFoodLabel()
        setFoodCountLabelConstraints()
        setFoodLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(recipe: [String:Any]) {
        foodLabel.text = "\(recipe["Label"] ?? "") (\(recipe["Cals"] ?? 0))"
        foodCountLabel.text = "x\(recipe["Count"] ?? 1)"
        self.data = recipe
    }
    
    func configureFoodCountLabel() {
        foodCountLabel.numberOfLines = 0
        foodCountLabel.adjustsFontSizeToFitWidth = true
        foodCountLabel.font = UIFont(name: "Futura", size: 15)
    }
    
    func configureFoodLabel() {
        foodLabel.numberOfLines = 0 // to word wrap
        foodLabel.adjustsFontSizeToFitWidth = true // shrink the fontsize if it's to big for the width
        foodLabel.font = UIFont(name: "Futura", size: 15)
    }

    func setFoodCountLabelConstraints() {
        foodCountLabel.translatesAutoresizingMaskIntoConstraints = false
        foodCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        foodCountLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setFoodLabelConstraints() {
        foodLabel.translatesAutoresizingMaskIntoConstraints = false
        foodLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        foodLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        foodLabel.trailingAnchor.constraint(equalTo: foodCountLabel.leadingAnchor, constant: -10).isActive = true
    }
}
