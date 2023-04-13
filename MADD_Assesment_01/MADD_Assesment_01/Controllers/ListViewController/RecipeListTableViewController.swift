//
//  RecipeListTableViewController.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-12.
//

import UIKit
import CoreData

extension RecipeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return filteredRecipes.count
        }
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSet: Recipe!
        if(searchController.isActive){
            dataSet = filteredRecipes[indexPath.row]
        }else{
            dataSet = recipeList[indexPath.row]
        }
        
        let cell = recipeTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.recipeNameLabel.text = dataSet.name
        cell.recipeNameDescription.text = dataSet.recipeDescription
        cell.recipeImageView.image  = UIImage(data: dataSet.imageName! as Data)
        cell.recipeImageView.makeRoundImage(imageCircle: false)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            context.delete(recipeList[indexPath.row] )
            recipeList.remove(at: indexPath.row)
            do {
                try context.save()
            } catch _ {
                print("Error, something went wrong")
            }
         
            recipeTable.deleteRows(at: [indexPath], with: .fade)
        }
       
    }
}
