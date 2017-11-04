//
//  ImagesService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

struct ImagesServiceConstants {
    static let didStartRetreivingImageNotification = Notification.Name("ImagesServiceConstants.didStartRetreivingImageNotification")
    static let didEndRetreivingImageNotification = Notification.Name("ImagesServiceConstants.didEndRetreivingImageNotification")
}

protocol ImagesService: class {
    func imagePromise(with urlString: String) -> ImageRetrievePromise
}

final class ImageRetrievePromise {
    
    private final let imageUrlString: String
    
    init(urlString: String) {
        self.imageUrlString = urlString
    }
    
    final var image: UIImage? {
        didSet {
            tryToNotify()
        }
    }
    
    final var error: Error? {
        didSet {
            tryToNotify()
        }
    }
    
    final var notifyCall: ((UIImage?, Error?) -> ())? {
        didSet {
            tryToNotify()
        }
    }
    
    private final func tryToNotify() {
        if let notifyCall = notifyCall {
            if error != nil || image != nil {
                notifyCall(image, error)
            }
        }
    }
}
