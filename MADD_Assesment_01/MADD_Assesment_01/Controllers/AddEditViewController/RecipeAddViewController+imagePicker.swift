//
//  RecipeAddViewController+imagePicker.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-12.
//

import UIKit

extension RecipeAddViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        selectedImage = image
        dismiss(animated: true)
    }
}
