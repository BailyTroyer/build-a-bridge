//
//  ReportCell.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 11/15/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sValue: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
