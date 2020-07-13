//
//  ThingTableViewCell.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/12/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
