//
//  RecipeAdd.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import Foundation
import UIKit
import CoreData

class RecipeAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var ingredients: UITextField!
    @IBOutlet weak var recipeDescription: UITextField!
    @IBOutlet weak var labelStepper: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var category: UITextField!
    
    var selectedRecipe: Recipe? = nil
    var selectedImage: UIImage? = nil
    var categoryPickerView = UIPickerView()
    var stepperValue: Double = 0;
    let alert = UIAlertController(title: "Alert", message: "Please fill all fields", preferredStyle: .alert)

    override func viewDidLoad() {
        self.imageView.makeRoundImage(imageCircle: true)
        
        labelStepper.text = String("This recipe will take at least 0 hours")
        self.category.inputView = categoryPickerView
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        categoryPickerView.tag = 1
 
        if(selectedRecipe != nil){
            recipeName.text = selectedRecipe?.name
            ingredients.text = selectedRecipe?.ingredients
            category.text = selectedRecipe?.recipeCategory
            recipeDescription.text = selectedRecipe?.recipeDescription
            stepper.value = selectedRecipe!.cookingTime
            stepperValue = selectedRecipe!.cookingTime
            imageView.image = UIImage(data: selectedRecipe!.imageName as Data)
            selectedImage = UIImage(data: selectedRecipe!.imageName as Data)
            labelStepper.text = String("This recipe will take at least \(Int(selectedRecipe!.cookingTime)) hours")
        }
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        stepperValue = Double(sender.value)
        labelStepper.text = String("This recipe will take at least \(Int(sender.value)) hours")
    }
    
    @IBAction func editImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let image = selectedImage?.jpegData(compressionQuality: 1) as NSData?
        let newRecipe = RecipeCustom(name: recipeName.text, recipeDescription: recipeDescription.text, imageName: image, ingredients: ingredients.text, recipeCategory: category.text, cookingTime: stepperValue)
        
        do{
            if(selectedRecipe == nil){
                let recipe = try Recipe.saveRecipe(recipe: newRecipe)
                recipeList.append(recipe)
            }else{
                try Recipe.editRecipe(passedInRecipe: newRecipe, selectedRecipe: selectedRecipe!)
            }
            navigationController?.popViewController(animated: true)
        }catch CustomError.requiredError{
            showToast(errorMessage: "All fields are required, please fill them")
            print("Reqiuired")
        }catch CustomError.outOfRange{
            showToast(errorMessage: "Time required cannot be larger than 10 hours")
            print("Out of range error")
        }catch CustomError.defaultError{
            showToast(errorMessage: "Something went wrong, please try again")
            print("Error")
        }catch {
            showToast(errorMessage: "Something went wrong, please try again")
            print("Error")
        }
    }
}

