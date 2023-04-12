//
//  roundImafeContentView.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-12.
//

import UIKit

extension UIImageView{

    func makeRoundImage(imageCircle rounded: Bool){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = rounded ? self.frame.size.height/2 : 20
        self.clipsToBounds = true
    }
    

}
