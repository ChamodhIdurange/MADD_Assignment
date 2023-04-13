//
//  recipeCustomModel.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-13.
//

import Foundation

class RecipeCustom{
    var name: String!
    var recipeDescription: String!
    var imageName: NSData!
    var ingredients: String!
    var recipeCategory: String!
    var cookingTime: Double
    
    init(name: String!, recipeDescription: String!, imageName: NSData!, ingredients: String!, recipeCategory: String!, cookingTime: Double) {
        self.name = name
        self.recipeDescription = recipeDescription
        self.imageName = imageName
        self.ingredients = ingredients
        self.recipeCategory = recipeCategory
        self.cookingTime = cookingTime
    }
}
