//
//  ImagesService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

@objc protocol ImagesService {
    func imagePromiseForUrl(urlString: String) -> ImageRetrievePromise
}

class ImageRetrievePromise: NSObject {
    
    let imageUrlString: String
    
    init(urlString: String) {
        self.imageUrlString = urlString
        super.init()
    }
    
    var image: UIImage? {
        didSet {
            tryToNotify()
        }
    }
    
    var error: NSError? {
        didSet {
            tryToNotify()
        }
    }
    
    var notifyCall: ((UIImage?, NSError?) -> ())? {
        didSet {
            tryToNotify()
        }
    }
    
    private func tryToNotify() {
        if let notifyCall = notifyCall {
            if error != nil || image != nil {
                notifyCall(image, error)
            }
        }
    }
}