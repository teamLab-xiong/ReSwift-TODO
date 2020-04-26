//
//  MasterItemCell.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/21.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

class MasterItemCell: UITableViewCell, NibReusable {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
}

extension MasterItemCell: Injectable {
    func inject(_ dependency: TODO) {
        titleLabel.text = dependency.title
        messageLabel.text = dependency.message
        dateLabel.text = dependency.date.description
    }
    
    typealias Dependency = TODO
}
