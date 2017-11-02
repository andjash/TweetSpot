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

// MARK: TweetDetailsModuleInput protocol
extension TweetDetailsPresenter : TweetDetailsModuleInput {
  
    func configureWithDTO(_ tweetDTO: AnyObject) {
        interactor.requestViewModelForDTO(tweetDTO)
    }
}

// MARK: TweetDetailsInteractorOutput protocol
extension TweetDetailsPresenter : TweetDetailsInteractorOutput {
    
    func updateWithViewModelItem(_ item: TweetDetailsViewModel) {
        view.configureWithItem(item)
    }
}
