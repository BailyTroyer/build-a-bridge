//
//  DesignableTextField.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/29/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            
            view.addSubview(imageView)
            
            leftView = view
        } else {
            // image is nil
            leftViewMode = .never
        }
    }
    
}
