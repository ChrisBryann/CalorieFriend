//
//  FoodResultLabel.swift
//  CalorieFriend
//
//  Created by Christopher Bryan on 08/03/23.
//

import UIKit

class FoodResultLabel: UIView {
    
    let label = UILabel()
    let deleteButton = UIButton()
    
    var data: [String: Any] = [:]
    
    init(data: [String: Any]) {
        super.init(frame: CGRectZero)
        configureSubviews()
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        // creating the label
        addSubview(label)
        label.font = UIFont(name: "Futura", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // creating the delete button
        addSubview(deleteButton)
        deleteButton.isEnabled = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }

    private func setup(data: [String: Any]) {
        self.data = data
        label.text = "\(self.data["Label"] as? String ?? "") (\(self.data["Cals"] as? Double ?? 0))"
    }
    
    @objc private func deleteButtonClicked() {
        print("delete button clicked!")
    }
}
