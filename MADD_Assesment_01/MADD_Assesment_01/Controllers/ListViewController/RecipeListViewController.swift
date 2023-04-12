//
//  ViewController.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import UIKit
import CoreData

var recipeList = [Recipe]()
let categoryList = ["Vegetarioan", "Non-vegitarian", "Appetizers", "Desserts"]

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var firstLoad = true
    let searchController = UISearchController()
    @IBOutlet weak var recipeTable: UITableView!
    var filteredRecipes = [Recipe]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        recipeTable.dataSource = self
        recipeTable.delegate = self

        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let recipe = result as! Recipe
                    recipeList.append(recipe)
                }
            }catch{
                print("Something went wront, Please try again")
            }
        }
    }
    
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

    @IBAction func editRecipe(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = self.recipeTable.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        
        self.performSegue(withIdentifier: "editRecipe", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let indexPath = self.recipeTable.indexPathForSelectedRow!
            let tableViewDetail = segue.destination as? RecipeDetailsViewController
           
            let selectedRecipe: Recipe!
            if(searchController.isActive){
                selectedRecipe = filteredRecipes[indexPath.row]
            }else{
                selectedRecipe = recipeList[indexPath.row]
            }
            
            tableViewDetail!.selectedRecipe = selectedRecipe
            self.recipeTable.deselectRow(at: indexPath, animated: true)
            
        }
        if(segue.identifier == "editRecipe"){
            let indexPath = sender as? IndexPath
            let indexPathRow = indexPath!.row
            let tableViewDetail = segue.destination as? RecipeAddViewController
           
            let selectedRecipe: Recipe!
            if(searchController.isActive){
                selectedRecipe = filteredRecipes[indexPathRow]
            }else{
                selectedRecipe = recipeList[indexPathRow]
            }
            
            tableViewDetail!.selectedRecipe = selectedRecipe
            self.recipeTable.deselectRow(at: indexPath!, animated: true)
            
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        recipeTable.reloadData()
    }
    
}
