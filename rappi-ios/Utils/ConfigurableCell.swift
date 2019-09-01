//
//  ConfigurableCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 01/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(model: DataType)
}

protocol CellConfigurator {
    var reuseId: String { get }
    func configure(cell: UITableViewCell)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    
    var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UITableViewCell) {
        (cell as! CellType).configure(model: item)
    }
}
