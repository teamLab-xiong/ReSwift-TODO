//
//  TODOModel.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation

struct TODO {
    var title: String
    var message: String?
    var date: Date
}

extension TODO: Equatable {}
extension TODO: Codable {}
