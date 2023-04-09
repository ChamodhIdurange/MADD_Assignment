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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
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
        // Do any additional setup after loading the view.
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
        cell.recipeImageView.image  = UIImage(named: "nil")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func initSearchController(){
        searchController.loadView()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Non-Veg", "Veg"]
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All"){
        filteredRecipes = recipeList.filter{
            recipe in
            let  scopeMatch = (scopeButton == "All" || recipe.name.lowercased().contains(searchText.lowercased()))
            if(searchController.searchBar.text != ""){
                let searchTextMatch = recipe.name.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }else{
                return scopeMatch
            }
        }
        recipeTable.reloadData()
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
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

extension UIView {
    func nearestAncestor<T>(ofType type: T.Type) -> T? {
        if let me = self as? T { return me }
        return superview?.nearestAncestor(ofType: type)
    }
}
