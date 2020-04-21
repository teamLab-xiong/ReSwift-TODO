//
//  DependencyInjectable.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/21.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

protocol Injectable {
    associatedtype Dependency
    
    func inject(_ dependency: Dependency)
}


extension Injectable where Self: UIView {
    
    func config(with dependency: Dependency) {
        inject(dependency)
    }
}
