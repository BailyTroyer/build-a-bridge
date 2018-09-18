//
//  SkillCell.swift
//  
//
//  Created by Baily Troyer on 8/20/18.
//

import UIKit

class SkillCell: UITableViewCell {

    @IBOutlet weak var skillImage: UIImageView!
    @IBOutlet weak var skillName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
