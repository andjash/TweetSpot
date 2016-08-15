//
//  TweetDetailsTweetDetailsInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class TweetDetailsInteractor: NSObject, TweetDetailsInteractorInput {

    weak var output: TweetDetailsInteractorOutput!
    weak var imagesService: ImagesService?
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.ts_configureAsAppCommonFormatter()
        super.init()
    }
    
    func requestViewModelForDTO(dtoObj: AnyObject) {
        guard let dto = dtoObj as? TweetDTO else { return }
        let result = TweetDetailsViewModel(id: dto.id,
                                           formattedPostDate: dateFormatter.stringFromDate(dto.creationDate),
                                           text: dto.text,
                                           userName: dto.userName,
                                           screenName: dto.screenName)
        promiseImagesLoad(result, dto: dto)
        output.updateWithViewModelItem(result)
    }
    
    private func promiseImagesLoad(item: TweetDetailsViewModel, dto: TweetDTO) {
        guard let imagesService = imagesService else { return }
        
        let smallPromise = imagesService.imagePromiseForUrl(dto.avatarUrlStr.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger"))
        smallPromise.notifyCall = { (img, error) in
            if let image = img {
                item.smallAvatar = image
                if let callback = item.smallAvatarRetrievedCallback {
                    callback()
                }
            }
        }
        
        let bigPromise = imagesService.imagePromiseForUrl(dto.avatarUrlStr.stringByReplacingOccurrencesOfString("_normal", withString: ""))
        bigPromise.notifyCall = { (img, error) in
            if let image = img {
                item.bigAvatar = image
                if let callback = item.avatarRetrievedCallback {
                    callback()
                }
            }
        }
    }
}
