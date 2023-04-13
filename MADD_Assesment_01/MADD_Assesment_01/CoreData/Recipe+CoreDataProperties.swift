//
//  Recipe+CoreDataProperties.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-13.
//

import UIKit
import CoreData
extension Recipe{
 
    static func saveRecipe(recipe: RecipeCustom) ->  Recipe{
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
            print("Something went wrong please try again")
        }
        return newRecipe
    }
    
    static func editRecipe(passedInRecipe: RecipeCustom, selectedRecipe: Recipe){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")

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
            print("Something went wront, Please try again")
        }
    }
}
