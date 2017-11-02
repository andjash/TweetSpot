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
    
    func imagePromiseForUrl(_ urlString: String) -> ImageRetrievePromise {
        let promise = ImageRetrievePromise(urlString: urlString)
        NotificationCenter.default.post(name: Notification.Name(rawValue: ImagesServiceConstants.didStartRetreivingImageNotification), object: self)
        let sgPromise = SGImageCache.getImageForURL(urlString)
        
        _ = sgPromise?.swiftThen({ object in
            NotificationCenter.default.post(name: Notification.Name(rawValue: ImagesServiceConstants.didEndRetreivingImageNotification), object: self)
            if let image = object as? UIImage {
                promise.image = image
            }
            return nil
        })
        
        sgPromise?.onFail = { (error: NSError?, wasFatal: Bool) -> () in
            NotificationCenter.default.post(name: Notification.Name(rawValue: ImagesServiceConstants.didEndRetreivingImageNotification), object: self)
            promise.error = error
        } as? SGCacheFetchFail
        
        return promise
    }
    
}


private extension PMKPromise {
    
    func objCBlockFromPromiseClosure(_ closure: @escaping (AnyObject) -> (PMKPromise?)) -> AnyObject {
        return unsafeBitCast(closure as @convention(block) (AnyObject) -> (PMKPromise?), to: AnyObject.self)
    }
    
    func swiftThen(_ closure: @escaping (AnyObject) -> (PMKPromise?)) -> PMKPromise {
        return self.then()(objCBlockFromPromiseClosure(closure))!
    }
}

