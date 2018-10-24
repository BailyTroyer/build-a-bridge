//
//  SkillCell.swift
//
//
//  Created by Baily Troyer on 8/20/18.
//
import Foundation
import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var lastMessageContent: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var lastMessageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        contactImage.layer.cornerRadius = contactImage.frame.height/2
//        contactImage.layer.masksToBounds = true
        
        contactImage?.layer.cornerRadius = (contactImage?.frame.size.width ?? 0.0) / 2
        contactImage?.clipsToBounds = true
        contactImage?.layer.borderWidth = 3.0
        contactImage?.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
