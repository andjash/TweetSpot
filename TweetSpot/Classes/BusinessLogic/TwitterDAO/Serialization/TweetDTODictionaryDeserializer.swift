//
//  TweetDTODictionaryDeserializer.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class TweetDTODictionaryDeserializer: NSObject, TweetDTODeserializer {
    func deserializeTweetDTOsFromObject(object: AnyObject) -> [TweetDTO]? {
        guard let arrayOfDicts = object as? NSArray else { return nil }
        
        var result: [TweetDTO] = []
        
        for dict in arrayOfDicts {
            guard let dict = dict as? NSDictionary else { continue }
            guard let id = dict["id_str"] as? String else { continue }
            guard let creationDateStr = dict["created_at"] as? String else { continue }
            guard let text = dict["text"] as? String else { continue }
            
            guard let userDict = dict["user"] as? NSDictionary  else { continue }
            guard let userName = userDict["name"] as? String else { continue }
            guard let avatarUrlStr = userDict["profile_image_url"] as? String else { continue }
            
            let dto = TweetDTO(id: id, creationDateSting: creationDateStr, text: text, userName: userName, avatarUrlString: avatarUrlStr)
            result.append(dto)
        }
        
        return result
    }
}
