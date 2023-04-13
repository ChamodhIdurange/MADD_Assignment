//
//  toastLabelView.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-13.
//

import UIKit

extension RecipeAddViewController{

    func showToast(errorMessage message: String){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-180, y: self.view.frame.height - 100, width: 350, height: 40))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.red
        toastLabel.textColor = UIColor.white
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }) {(isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
    

}
