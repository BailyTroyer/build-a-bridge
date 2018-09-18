//
//  SkillSelectCell.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/31/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import UIKit

class SkillSelectCell: UITableViewCell {
    
    //@IBOutlet weak var skillImage: UIImageView!
    //@IBOutlet weak var name: UILabel!
    @IBOutlet weak var skillImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
