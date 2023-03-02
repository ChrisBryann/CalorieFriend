//
//  RecipeCell.swift
//  CalorieFriend
//
//  Created by Brandon on 2/28/23.
//

import UIKit

protocol RecipeCellDelegate: AnyObject {
    func didTapAddRecipeButton(with recipe: Recipe)
}

class RecipeCell: UITableViewCell {

    weak var delegate: RecipeCellDelegate?
    
    static let identifier = "RecipeCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RecipeCell", bundle: nil)
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var addRecipeButton: UIButton!
    @IBOutlet var recipeLinkButon: UIButton!
    private var recipe: Recipe?
    
    @IBAction func didTapAddRecipeButton() {
        delegate?.didTapAddRecipeButton(with: self.recipe!)
    }
    
    @IBAction func didTapRecipeLinkButton() {
        
    }
    
    func configure(with recipe: Recipe) {
        self.recipe = recipe
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = "\(recipe.source!): \(recipe.label!) - \(round(recipe.calories!)) calories"
        addRecipeButton.setTitle("Add Recipe", for: .normal)
        recipeLinkButon.setTitle("Recipe Link", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
