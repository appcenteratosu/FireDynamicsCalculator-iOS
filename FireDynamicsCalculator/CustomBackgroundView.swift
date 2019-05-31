////
//  CustomBackgroundView.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 5/30/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class CustomBackgroundView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    private func common() {
        self.backgroundColor = #colorLiteral(red: 0.2506330311, green: 0.2552646995, blue: 0.2639723122, alpha: 1)
        self.layer.cornerRadius = 5
    }
    
}
