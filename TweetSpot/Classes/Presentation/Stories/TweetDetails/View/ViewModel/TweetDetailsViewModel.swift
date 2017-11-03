//
//  TweetDetailsViewModel.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class TweetDetailsViewModel {
    final let id: String
    final let formattedPostDate: String
    final let text: String
    final let userName: String
    final let screenName: String
    
    final var smallAvatar: UIImage?
    final var smallAvatarRetrievedCallback: (() -> ())?
    
    final var bigAvatar: UIImage?
    final var avatarRetrievedCallback: (() -> ())?
    
    init(id: String, formattedPostDate: String, text: String, userName: String, screenName: String) {
        self.id = id
        self.formattedPostDate = formattedPostDate
        self.text = text
        self.userName = userName
        self.screenName = screenName
    }
}
