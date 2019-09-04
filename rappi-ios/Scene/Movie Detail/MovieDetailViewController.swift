//
//  MovieDetailViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 02/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.primaryDarkColor
    }

}

extension MovieDetailViewController: DetailTransitionViewProtocol {
    func transitionImageView() -> UIImageView {
        return self.imageView
    }
}
