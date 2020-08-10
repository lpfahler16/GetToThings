//
//  RecurringViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class RecurringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recurringTable: UITableView!
    let header = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recurringTable.delegate = self
        recurringTable.dataSource = self
    }
    

    
    //MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
