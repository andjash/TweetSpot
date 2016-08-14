//
//  TweetDetailsTweetDetailsPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class TweetDetailsPresenter: NSObject, TweetDetailsViewOutput {

    weak var view: TweetDetailsViewInput!
    var interactor: TweetDetailsInteractorInput!
    var router: TweetDetailsRouterInput!

    func viewIsReady() {

    }
    
    
}

extension TweetDetailsPresenter : TweetDetailsModuleInput {
    func configureWithDTO(tweetDTO: AnyObject) {
        interactor.requestViewModelForDTO(tweetDTO)
    }
}


extension TweetDetailsPresenter : TweetDetailsInteractorOutput {
    
    func updateWithViewModelItem(item: TweetDetailsViewModel) {
        view.configureWithItem(item)
    }
}
