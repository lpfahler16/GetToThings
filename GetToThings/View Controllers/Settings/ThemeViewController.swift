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
    
    @IBAction func goBlue(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "color")
        SceneDelegate().updateColor()
        info()
    }
    
    @IBAction func goRed(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "color")
        SceneDelegate().updateColor()
        info()
    }
    
    @IBAction func goGreen(_ sender: Any) {
        UserDefaults.standard.set(2, forKey: "color")
        SceneDelegate().updateColor()
        info()
    }
    
    @IBAction func goPurple(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "color")
        SceneDelegate().updateColor()
        info()
    }
    
    func dismissViewControllers() {

        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func info() {
        let alertController = UIAlertController(title: "Theme", message:
            "Please close the app to finish the theme change.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: { action in
            
            self.dismissViewControllers()
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
