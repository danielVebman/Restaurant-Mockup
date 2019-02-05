//
//  Toolbar.swift
//  Restaurant Mockup
//
//  Created by Daniel Vebman on 10/22/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class RestaurantToolbar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let images = [#imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "chef"), #imageLiteral(resourceName: "compass"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "person")]
        for (n, image) in images.enumerated() {
            let button = UIButton(type: .system)
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            button.frame.size = CGSize(width: 25, height: 25)
            button.frame.origin.y = 20
            button.center.x = frame.width * CGFloat(n + 1) / CGFloat(images.count + 1)
            addSubview(button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
