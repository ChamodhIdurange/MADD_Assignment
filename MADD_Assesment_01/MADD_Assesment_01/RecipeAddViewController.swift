//
//  RecipeAdd.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-08.
//

import Foundation
import UIKit
import CoreData

class RecipeAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

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
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.darkGray.cgColor
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = imageView.frame.size.height/2
        self.imageView.clipsToBounds = true
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
    
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
            @unknown default:
                print("Error")
            }
        }))
        
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
            imageView.image = UIImage(data: selectedRecipe!.imageName as Data)
            selectedImage = UIImage(data: selectedRecipe!.imageName as Data)
            labelStepper.text = String("This recipe will take at least \(Int(selectedRecipe!.cookingTime)) hours")
        }
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        print(sender.value)
        stepperValue = Double(sender.value)
        
        labelStepper.text = String("This recipe will take at least \(Int(sender.value)) hours")
    }
    
    @IBAction func editImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        selectedImage = image
        dismiss(animated: true)
    
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(recipeName.text == "" || ingredients.text == "" || category.text == "" || recipeDescription.text == "" || stepperValue == 0 || selectedImage == nil){
            self.present(alert, animated: true, completion: nil)
            return
        }
        if(selectedRecipe == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
            let newRecipe = Recipe(entity: entity!, insertInto: context)
            newRecipe.name = recipeName.text
            newRecipe.ingredients = ingredients.text
            newRecipe.recipeCategory = category.text
            newRecipe.recipeDescription = recipeDescription.text
            newRecipe.cookingTime = stepperValue
            newRecipe.imageName = selectedImage?.jpegData(compressionQuality: 1) as NSData?
            
            
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
                        recipe.ingredients = ingredients.text
                        recipe.recipeCategory = category.text
                        recipe.recipeDescription = recipeDescription.text
                        recipe.cookingTime = stepperValue
                        recipe.imageName = selectedImage?.jpegData(compressionQuality: 1) as NSData?
                        
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }catch{
                print("Something went wront, Please try again")
            }
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return categoryList.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return categoryList[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            category.text = categoryList[row]
            category.resignFirstResponder()
        default:
            return
        }
    }
    
}
