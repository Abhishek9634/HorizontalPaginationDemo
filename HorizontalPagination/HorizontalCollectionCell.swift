//
//  HorizontalCollectionCell.swift
//  PaginationUIManager-Example
//
//  Created by Abhishek Thapliyal on 14/07/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit

class HorizontalCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(index: Int) {
        self.titleLabel.text = "\(index) Value"
        self.backgroundColor = index % 2 == 0 ? .lightGray : .lightText
    }
    
}
