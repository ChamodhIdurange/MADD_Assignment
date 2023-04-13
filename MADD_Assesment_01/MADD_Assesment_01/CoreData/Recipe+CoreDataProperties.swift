//
//  Recipe+CoreDataProperties.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-13.
//

import UIKit
import CoreData
extension Recipe{
 
    static func saveRecipe(recipe: RecipeCustom)throws ->  Recipe{
        
        if(recipe.name == "" || recipe.ingredients == "" || recipe.recipeCategory == "" || recipe.recipeDescription! == "" || recipe.cookingTime == 0 || recipe.imageName == nil){
            throw CustomError.requiredError
        }else if(recipe.cookingTime >= 10){
            throw CustomError.outOfRange
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        let newRecipe = Recipe(entity: entity!, insertInto: context)
        
        newRecipe.name = recipe.name
        newRecipe.ingredients = recipe.ingredients
        newRecipe.recipeCategory = recipe.recipeCategory
        newRecipe.recipeDescription = recipe.recipeDescription
        newRecipe.cookingTime = recipe.cookingTime
        newRecipe.imageName = recipe.imageName
        
        do{
            try context.save()
        }catch{
            throw CustomError.defaultError
        }
        return newRecipe
    }
    
    static func editRecipe(passedInRecipe: RecipeCustom, selectedRecipe: Recipe) throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")

        if(passedInRecipe.name == "" || passedInRecipe.ingredients == "" || passedInRecipe.recipeCategory == "" || passedInRecipe.recipeDescription! == "" || passedInRecipe.cookingTime == 0 || passedInRecipe.imageName == nil){
            throw CustomError.requiredError
        }else if(passedInRecipe.cookingTime >= 10){
            throw CustomError.outOfRange
        }
        
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let recipe = result as! Recipe
                if(recipe == selectedRecipe){
                    recipe.name = passedInRecipe.name
                    recipe.ingredients = passedInRecipe.ingredients
                    recipe.recipeCategory = passedInRecipe.recipeCategory
                    recipe.recipeDescription = passedInRecipe.recipeDescription
                    recipe.cookingTime = passedInRecipe.cookingTime
                    recipe.imageName = passedInRecipe.imageName
                    try context.save()
                }
            }
        }catch{
            throw CustomError.defaultError
        }
    }
}
