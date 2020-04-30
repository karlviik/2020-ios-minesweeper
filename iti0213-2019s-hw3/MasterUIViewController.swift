//
//  MasterUIViewController.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 2/11/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import UIKit

class MasterUIViewController: UIViewController {
    
    @IBOutlet weak var themeSelector: UISegmentedControl!

    @IBOutlet weak var flagIconTextField: UITextField!
    @IBOutlet weak var bombIconTextField: UITextField!
    @IBOutlet weak var explosionIconTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        flagIconTextField.text = "🚩"
        flagIconTextField.delegate = self
        bombIconTextField.text = "💣"
        bombIconTextField.delegate = self
        explosionIconTextField.text = "💥"
        explosionIconTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "customGameSettingsSegue":
                if let vc = segue.destination as? CustomGameUIViewController {
                    vc.bombIcon = bombIconTextField.text!
                    vc.flagIcon = flagIconTextField.text!
                    vc.explosionIcon = explosionIconTextField.text!
                    vc.theme = themeSelector.selectedSegmentIndex
                }
            case "HardNewGameSegue":
                if let vc = segue.destination as? MinesweeperViewController {
                    vc.bombIcon = bombIconTextField.text!
                    vc.flagIcon = flagIconTextField.text!
                    vc.explosionIcon = explosionIconTextField.text!
                    vc.theme = themeSelector.selectedSegmentIndex
                    vc.bombPercentage = 0.3
                }
            case "MediumNewGameSegue":
                if let vc = segue.destination as? MinesweeperViewController {
                    vc.bombIcon = bombIconTextField.text!
                    vc.flagIcon = flagIconTextField.text!
                    vc.explosionIcon = explosionIconTextField.text!
                    vc.theme = themeSelector.selectedSegmentIndex
                    vc.bombPercentage = 0.2
                }
            case "EasyNewGameSegue":
                if let vc = segue.destination as? MinesweeperViewController {
                    vc.bombIcon = bombIconTextField.text!
                    vc.flagIcon = flagIconTextField.text!
                    vc.explosionIcon = explosionIconTextField.text!
                    vc.theme = themeSelector.selectedSegmentIndex
                    vc.bombPercentage = 0.1
                }
            default: break
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension MasterUIViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
