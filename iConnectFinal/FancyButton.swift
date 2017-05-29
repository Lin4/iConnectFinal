//
//  FancyButton.swift
//  iConnectFinal
//
//  Created by Lingeswaran Kandasamy on 5/28/17.
//  Copyright © 2017 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6) .cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView? . contentMode = .scaleAspectFit
        layer.cornerRadius = 3.0
    }

}
