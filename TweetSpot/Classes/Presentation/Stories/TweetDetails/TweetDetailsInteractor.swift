//
//  TweetDetailsTweetDetailsInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class TweetDetailsInteractor {

    final weak var output: TweetDetailsPresenter!
    final weak var imagesService: ImagesService?
    final let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.ts_configureAsAppCommonFormatter()
    }
    
    // MARK: - Input
    
    final func requestViewModelForDTO(_ dtoObj: AnyObject) {
        guard let dto = dtoObj as? TweetDTO else { return }
        let result = TweetDetailsViewModel(id: dto.id,
                                           formattedPostDate: dateFormatter.string(from: dto.creationDate as Date),
                                           text: dto.text,
                                           userName: dto.userName,
                                           screenName: dto.screenName)
        promiseImagesLoad(result, dto: dto)
        output.updateWithViewModelItem(result)
    }
    
    // MARK: - Private
    
    final private func promiseImagesLoad(_ item: TweetDetailsViewModel, dto: TweetDTO) {
        guard let imagesService = imagesService else { return }
        
        let smallPromise = imagesService.imagePromiseForUrl(dto.avatarUrlStr.replacingOccurrences(of: "_normal", with: "_bigger"))
        smallPromise.notifyCall = { (img, error) in
            if let image = img {
                item.smallAvatar = image
                if let callback = item.smallAvatarRetrievedCallback {
                    callback()
                }
            }
        }
        
        let bigPromise = imagesService.imagePromiseForUrl(dto.avatarUrlStr.replacingOccurrences(of: "_normal", with: ""))
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
