//
//  MyTableViewCell.swift
//  UrlSessionLesson
//
//  Created by Лада on 22/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.textLabel?.text = ""
        self.imageView?.image = nil
    }
}
