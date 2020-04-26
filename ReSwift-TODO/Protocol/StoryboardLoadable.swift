//
//  StoryboardLoadable.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/26.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardLoadable: class {
    static var storyboard: UIStoryboard { get }
}

extension StoryboardLoadable {
    static var storyboard: UIStoryboard {
        let fullName = String(describing: self)
        let name: String
        if fullName.contains("ViewController") {
            let length = fullName.count - "ViewController".count
            name = String(fullName.prefix(length))
            return .init(name: name, bundle: .init(for: self))
        } else if fullName.contains("Controller") {
            let length = fullName.count - "Controller".count
            name = String(fullName.prefix(length))
            return .init(name: name, bundle: .init(for: self))
        } else {
            return .init(name: fullName, bundle: .init(for: self))
        }
    }
}

extension StoryboardLoadable where Self: UIViewController {
    static func instantiate() -> Self {
        let vc = storyboard.instantiateInitialViewController()
        guard let typed = vc as? Self else { fatalError("") }
        
        return typed
    }
}
