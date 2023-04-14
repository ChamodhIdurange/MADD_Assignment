//
//  RecipeListView+SearchController.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-12.
//

import UIKit

extension RecipeListViewController: UISearchBarDelegate, UISearchResultsUpdating{
    func initSearchController(){
        searchController.loadView()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All"] + categoryList.map { $0.rawValue }
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
            let  scopeMatch = (scopeButton == "All" || recipe.recipeCategory.lowercased().contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != ""){
                let searchTextMatch = recipe.name.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }else{
                return scopeMatch
            }
        }
        recipeTable.reloadData()
    }
    
}
