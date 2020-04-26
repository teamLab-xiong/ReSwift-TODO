//
//  NibReusable.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/26.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

/// **NibReusable** requires the .swift, .xib and the reuseIdentifier are set
/// to a string 

protocol NibReusable: class {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension NibReusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        .init(nibName: String(describing: self), bundle: .init(for: self))
    }
}

