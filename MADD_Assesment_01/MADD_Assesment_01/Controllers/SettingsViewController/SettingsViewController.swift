//
//  Settings.swift
//  MADD_Assesment_01
//
//  Created by Chamodh Abeygoonawardana on 2023-04-10.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.makeRoundImage(imageCircle: false)
        
        themeSwitch.isOn = false
        themeLabel.text = "Light"
        
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if themeSwitch.isOn == true{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            themeLabel.text = "Dark"
        }else{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            themeLabel.text = "Light"
        }
    }
}
