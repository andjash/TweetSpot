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
        
        var result: [TweetDTO] = []
        let dateFormatter = DateFormatter.st_Twitter()
        
        for dict in object {
            guard let dict = dict as? [AnyHashable : Any] else { continue }
            guard let id = dict["id_str"] as? String else { continue }
            guard let creationDateStr = dict["created_at"] as? String else { continue }
            guard let creationDate =  dateFormatter?.date(from: creationDateStr) else {continue}
            guard let text = dict["text"] as? String else { continue }
            guard let userDict = dict["user"] as? NSDictionary  else { continue }
            guard let userName = userDict["name"] as? String else { continue }
            guard let screenName = userDict["screen_name"] as? String else { continue }
            guard let avatarUrlStr = userDict["profile_image_url_https"] as? String else { continue }
            
            let dto = TweetDTO(id: id, creationDate: creationDate, text: text, userName: userName, screenName: screenName, avatarUrlString: avatarUrlStr)
            result.append(dto)
        }
        
        return result
    }
}
