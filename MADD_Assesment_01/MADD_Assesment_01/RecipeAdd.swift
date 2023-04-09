//
//  RecipeAdd.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import Foundation
import UIKit
import CoreData

class RecipeAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var ingredients: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var recipeDescription: UITextField!
    @IBOutlet weak var cookingTime: UITextField!
    
    var selectedRecipe: Recipe? = nil
    var imageName: String = "";
    
    override func viewDidLoad() {
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = imageView.frame.size.height/2
        self.imageView.clipsToBounds = true
 
        if(selectedRecipe != nil){
            recipeName.text = selectedRecipe?.name
            ingredients.text = selectedRecipe?.ingredients
            category.text = selectedRecipe?.recipeCategory
            recipeDescription.text = selectedRecipe?.recipeDescription
            cookingTime.text = selectedRecipe?.imageName
            //recipeName.text = selectedRecipe?.name
        }
    }
    
    @IBAction func editImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imageName = ""
        imageView.image = image
        dismiss(animated: true)
        
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imageName = url.lastPathComponent
        }
        print(imageName)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedRecipe == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
            let newRecipe = Recipe(entity: entity!, insertInto: context)
            newRecipe.name = recipeName.text
            newRecipe.cookingTime = 4.0
            newRecipe.ingredients = ingredients.text
            newRecipe.recipeDescription = recipeDescription.text
            newRecipe.imageName = imageName
            newRecipe.recipeCategory = category.text
            
            do{
                try context.save()
                recipeList.append(newRecipe)
                navigationController?.popViewController(animated: true)
            }catch{
                print("Error")
            }
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let recipe = result as! Recipe
                    if(recipe == selectedRecipe){
                        recipe.name = recipeName.text
                        recipe.cookingTime = 5.6
                        recipe.ingredients = ingredients.text
                        recipe.recipeDescription = recipeDescription.text
                        recipe.recipeCategory = category.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }catch{
                print("Something went wront, Please try again")
            }
            
        }
        
    }
    
}
