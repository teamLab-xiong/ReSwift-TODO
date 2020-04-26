//
//  DetailItelCell.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/26.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

class DetailItemCell: UITableViewCell {
    @IBOutlet fileprivate weak var messageLabel: UILabel!
}

extension DetailItemCell: Injectable {
    typealias Dependency = String?
    func inject(_ dependency: Dependency) {
        messageLabel.text = dependency
    }
}
