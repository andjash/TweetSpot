//
//  ImagesServiceImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import SGImageCache

class ImagesServiceImpl: NSObject, ImagesService {
    
    func imagePromiseForUrl(urlString: String) -> ImageRetrievePromise {
        let promise = ImageRetrievePromise(urlString: urlString)
        NSNotificationCenter.defaultCenter().postNotificationName(ImagesServiceConstants.didStartRetreivingImageNotification, object: self)
        let sgPromise = SGImageCache.getImageForURL(urlString)
        
        sgPromise.swiftThen({ object in
            NSNotificationCenter.defaultCenter().postNotificationName(ImagesServiceConstants.didEndRetreivingImageNotification, object: self)
            if let image = object as? UIImage {
                promise.image = image
            }
            return nil
        })
        
        sgPromise.onFail = { (error: NSError?, wasFatal: Bool) -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(ImagesServiceConstants.didEndRetreivingImageNotification, object: self)
            promise.error = error
        }
        
        return promise
    }
    
}


private extension PMKPromise {
    
    private func objCBlockFromPromiseClosure(closure: (AnyObject) -> (PMKPromise?)) -> AnyObject {
        return unsafeBitCast(closure as @convention(block) (AnyObject) -> (PMKPromise?), AnyObject.self)
    }
    
    func swiftThen(closure: (AnyObject) -> (PMKPromise?)) -> PMKPromise {
        return self.then()(objCBlockFromPromiseClosure(closure))
    }
}

