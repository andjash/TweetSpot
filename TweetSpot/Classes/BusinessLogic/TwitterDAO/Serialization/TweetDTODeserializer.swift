//
//  TweetDTODictionaryDeserializer.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

protocol TweetDTODeserializer: class {
    func deserializeTweetDTOs(from object: [Any]) -> [TweetDTO]?
}

final class TweetDTODictionaryDeserializer: TweetDTODeserializer {
    
    final func deserializeTweetDTOs(from object:  [Any]) -> [TweetDTO]? {
        let dateFormatter = DateFormatter.st_Twitter()
        let result: [TweetDTO] = object.flatMap { dict in
            guard let dict = dict as? [AnyHashable : Any] else { return nil }
            guard let id = dict["id_str"] as? String else { return nil }
            guard let creationDateStr = dict["created_at"] as? String else { return nil }
            guard let creationDate =  dateFormatter?.date(from: creationDateStr) else { return nil }
            guard let text = dict["text"] as? String else { return nil }
            guard let userDict = dict["user"] as? NSDictionary  else { return nil }
            guard let userName = userDict["name"] as? String else { return nil }
            guard let screenName = userDict["screen_name"] as? String else { return nil }
            guard let avatarUrlStr = userDict["profile_image_url_https"] as? String else { return nil }
            
            return TweetDTO(id: id,
                               creationDate: creationDate,
                               text: text,
                               userName: userName,
                               screenName: screenName,
                               avatarUrlStr: avatarUrlStr)
        }
        return result
    }
}
