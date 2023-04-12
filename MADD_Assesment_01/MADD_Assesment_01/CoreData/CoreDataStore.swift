//
//  CoreDataStore.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-12.
//

import Foundation
import UIKit
import CoreData

class CoreDataStore {
    func fetchData() -> [Recipe] {
        var recipes = [Recipe]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let recipe = result as! Recipe
                recipes.append(recipe)
            }
        }catch{
            print("Something went wront, Please try again")
        }
        
        return recipes;
    }
}
