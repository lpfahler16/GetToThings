//
//  ThemeViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/28/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func goBlue(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "color")
    }
    
    @IBAction func goRed(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "color")
    }
    
    @IBAction func goGreen(_ sender: Any) {
        UserDefaults.standard.set(2, forKey: "color")
    }
    
    @IBAction func goPurple(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "color")
    }
    
}
