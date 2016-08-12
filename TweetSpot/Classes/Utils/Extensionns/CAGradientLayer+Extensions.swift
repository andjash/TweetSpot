//
//  CAGradientLayer+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    static var ts_applicationPrimaryGradient: CAGradientLayer {
        let gLayer = CAGradientLayer()
        gLayer.colors = [UIColor.ts_applicationSecondaryColor, UIColor.ts_applicationPrimaryColor.CGColor]
        gLayer.locations = [0.0 , 1.0]
        gLayer.startPoint = CGPoint(x: 0, y: 0)
        gLayer.endPoint = CGPoint(x: 0, y: 2)
        return gLayer
    }
    
}
