//
//  TweetDetailsTweetDetailsViewInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol TweetDetailsViewInput {

    /**
        @author Andrey Yashnev
        Setup initial state of the view
    */

    func configureWithItem(_ item: TweetDetailsViewModel)
}
