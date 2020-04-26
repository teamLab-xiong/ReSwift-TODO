//
//  TableView+NibReusable.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/26.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,cellType: T.Type = T.self)
        -> T where T: NibReusable
    {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("")
        }
        return cell
    }
}
