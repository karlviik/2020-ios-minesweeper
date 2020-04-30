//
//  CustomGameUIViewController.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 2/11/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import UIKit

class CustomGameUIViewController: UIViewController {

    @IBOutlet weak var bombSliderOutlet: UISlider!
    @IBOutlet weak var boardSizeSliderOutlet: UISlider!
    
    var flagIcon: String = ""
    var bombIcon: String = ""
    var explosionIcon: String = ""
    var theme: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "CustomNewGameSegue":
                if let vc = segue.destination as? MinesweeperViewController {
                    vc.flagIcon = self.flagIcon
                    vc.bombIcon = self.bombIcon
                    vc.explosionIcon = self.explosionIcon
                    vc.theme = self.theme
                    vc.bombPercentage = self.bombSliderOutlet.value
                    vc.gameBoardSize = self.boardSizeSliderOutlet.value
                }
            default: break
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
