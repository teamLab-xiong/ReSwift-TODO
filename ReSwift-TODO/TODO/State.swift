//
//  State.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import ReSwift

protocol Reducible where Self: StateType {
    static var reducer: Reducer<Self> { get }
}

struct State: StateType {
    
    var todos: [TODO] = []
    
    init() {
        todos = Cache.shared.todos
    }
}

extension State: Reducible {
    static var reducer: (_ action: Action, _ state: State?) -> State {
        { action, state in
            var newState = state ?? State()
            
            switch action {
            case let action as AddTODO:
                newState.todos.append(action.todo)
            case let action as RemoveTODO:
                newState.todos.removeAll { $0 == action.todo }
            default:
                break
            }
            
            return newState
        }
    }
}


