//
//  TweetDetailsTweetDetailsPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class TweetDetailsPresenter: NSObject {

    final weak var view: TweetDetailsViewController!
    final var interactor: TweetDetailsInteractor!
   
    // MARK: - Module input
    
    final func configureWithDTO(_ tweetDTO: AnyObject) {
        interactor.requestViewModelForDTO(tweetDTO)
    }
    
    // MARK: - Interactor output

    final func updateWithViewModelItem(_ item: TweetDetailsViewModel) {
        view.configureWithItem(item)
    }
    
}

