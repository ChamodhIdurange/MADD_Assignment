//
//  Categories.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-14.
//

import Foundation


enum Categories: String {
  case Appetizers
  case Desserts
  case Salads
  case Entree
  case Sides
}
func getCategoryName(category: Categories) -> String? {
    return category.rawValue
}
