//
//  SearchBarHeaderView.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 05/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UIView {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.tintColor = UIColor.secondaryColor
            self.searchBar.barTintColor = UIColor.primaryColor
            self.searchBar.returnKeyType = .done
        }
    }
    
    static func buildView() -> SearchBarHeaderView {
        return (Bundle.main.loadNibNamed("SearchBarHeaderView", owner: self, options: nil)?.first as? UIView as! SearchBarHeaderView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.primaryDarkColor
    }
    
}
