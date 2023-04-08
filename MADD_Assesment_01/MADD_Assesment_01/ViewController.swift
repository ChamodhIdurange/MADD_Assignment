//
//  ViewController.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    let searchController = UISearchController()
    @IBOutlet weak var recipeTable: UITableView!
    var filteredRecipes = [Recipe]()

    var data = [
        Recipe(name: "Name 01", description: "Description 01", imageName: "meat", ingredients: ["1", "2", "3", "4", "5"], cookingTime: "10"),
        Recipe(name: "Name 02", description: "Description 02", imageName: "meat", ingredients: ["1", "2", "3", "4", "5"], cookingTime: "10"),
        Recipe(name: "Name 03", description: "Description 03", imageName: "meat", ingredients: ["1", "2", "3", "4", "5"], cookingTime: "10"),
        Recipe(name: "Name 04", description: "Description 04", imageName: "meat", ingredients: ["1", "2", "3", "4", "5"], cookingTime: "10"),
        Recipe(name: "Name 05", description: "Description 05", imageName: "meat", ingredients: ["1", "2", "3", "4", "5"], cookingTime: "10")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTable.dataSource = self
        recipeTable.delegate = self
        initSearchController()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return filteredRecipes.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSet: Recipe!
        if(searchController.isActive){
            dataSet = filteredRecipes[indexPath.row]
        }else{
            dataSet = data[indexPath.row]
        }
        
        let cell = recipeTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.recipeNameLabel.text = dataSet.name
        cell.recipeNameDescription.text = dataSet.description
        cell.recipeImageView.image  = UIImage(named: dataSet.imageName)
        
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
        filteredRecipes = data.filter{
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let indexPath = self.recipeTable.indexPathForSelectedRow!
            let tableViewDetail = segue.destination as? RecipeDetailsViewController
           
            let selectedRecipe: Recipe!
            if(searchController.isActive){
                selectedRecipe = filteredRecipes[indexPath.row]
            }else{
                selectedRecipe = data[indexPath.row]
            }
            
            tableViewDetail!.selectedRecipe = selectedRecipe
            self.recipeTable.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        recipeTable.beginUpdates()
        data.remove(at: indexPath.row)
        recipeTable.deleteRows(at: [indexPath], with: .fade)
        recipeTable.endUpdates()
    }
    
}

