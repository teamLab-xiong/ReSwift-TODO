//
//  Middleware.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/20.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import ReSwift

let cacheMiddleware: Middleware<State> = { dispatch, state in
    { next in
        { action in
            defer { next(action) }
            
            switch action {
            case let ac as AddTODO:
                Cache.shared.insert(ac.todo)
            case let ac as RemoveTODO:
                Cache.shared.remove(ac.todo)
            default:
                break
            }
        }
    }
}
