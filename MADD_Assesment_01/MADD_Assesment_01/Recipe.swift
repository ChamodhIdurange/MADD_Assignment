//
//  Recipe.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject{
    @NSManaged var name: String!
    @NSManaged var recipeDescription: String!
    @NSManaged var imageName: String!
    @NSManaged var ingredients: String!
    @NSManaged var recipeCategory: String!
    @NSManaged var cookingTime: Double
    
}
