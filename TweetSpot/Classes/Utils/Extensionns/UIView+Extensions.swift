//
//  UIView+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

extension UIView {
    
    static func ts_loadFromDefaultNib<T>() -> T! {
        let nibViews  = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        if !(nibViews?.isEmpty)! {
            if let result = nibViews?.first as? T {
                return result;
            }
        }
        return nil
    }
    
}
