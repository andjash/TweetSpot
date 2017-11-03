//
//  PresentationRegistry
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

final class PresentationRegistry: AYRegistry {
    
    override init() {
        super.init()
        
        register(lifetime: .singleton(lazy: false), initCall: { NavigationRootRegistry() })
        register(lifetime: .singleton(lazy: false), initCall: { LoginModuleRegistry() })
        register(lifetime: .singleton(lazy: false), initCall: { SpotModuleRegistry() })
        register(lifetime: .singleton(lazy: false), initCall: { TweetDetailsRegistry() })
        register(lifetime: .singleton(lazy: false), initCall: { SettingsModuleRegistry() })
    }
}
