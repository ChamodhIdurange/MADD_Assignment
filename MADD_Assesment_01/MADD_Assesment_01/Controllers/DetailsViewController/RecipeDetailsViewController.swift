//
//  RecipeDetails.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import Foundation
import UIKit

class RecipeDetailsViewController: UIViewController{
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeCategory: UILabel!
    
    var selectedRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeImage.makeRoundImage(imageCircle: false)
        recipeName.text = selectedRecipe.name
        recipeImage.image = UIImage(data: selectedRecipe.imageName! as Data)
        recipeCategory.text = selectedRecipe.recipeCategory
        recipeIngredients.text = selectedRecipe.ingredients
        recipeTime.text = String(selectedRecipe.cookingTime)
        recipeDescription.text = selectedRecipe.recipeDescription
    }
}
