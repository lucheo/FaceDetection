//
//  CheckButton.swift
//  FaceDetection2
//
//  Created by Lucheo Antonio Tombini Filho on 29/10/16.
//  Copyright © 2016 Lucheo Antonio Tombini Filho. All rights reserved.
//

import UIKit

class CheckButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(red: 10.0/255.0, green: 16.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        setTitleColor(UIColor.init(white: 1.0, alpha: 1.0), for: .normal)
    }
    
    
}
