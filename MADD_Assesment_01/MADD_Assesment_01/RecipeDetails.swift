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
    @IBOutlet weak var reipeImage: UIImageView!
    
    var selectedRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeName.text = selectedRecipe.name
        reipeImage.image = UIImage(data: selectedRecipe.imageName! as Data)
    }
}
