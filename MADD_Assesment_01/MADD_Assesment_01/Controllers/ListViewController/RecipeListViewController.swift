//
//  ViewController.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import UIKit
import CoreData

var recipeList = [Recipe]()
let categoryList = [Categories.Appetizers, Categories.Desserts, Categories.Entree, Categories.Salads]

class RecipeListViewController: UIViewController {
    
    let dataStore = CoreDataStore()
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
            recipeList = dataStore.fetchData()
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        recipeTable.reloadData()
    }
    
}
