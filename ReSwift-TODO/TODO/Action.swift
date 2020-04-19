//
//  Action.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import ReSwift

struct AddTODO: Action {
    var todo: TODO
}

struct RemoveTODO: Action {
    var todo: TODO
}
