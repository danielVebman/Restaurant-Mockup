//
//  ViewController.swift
//  Restaurant Mockup
//
//  Created by Daniel Vebman on 10/22/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import UIKit
import Cosmos

class MainViewController: UIViewController {
    var backgroundCircle: UIView!
    var titleLabel: UILabel!
    var searchButton: UIButton!
    var tableView: RestaurantsTableView!
    
    override func viewDidLoad() {
        backgroundCircle = UIView(frame: CGRect(x: -50, y: -70, width: view.frame.width * 4 / 5, height: view.frame.width * 4 / 5))
        backgroundCircle.layer.cornerRadius = 0.5 * backgroundCircle.frame.width
        backgroundCircle.clipsToBounds = true
        let layer = CAGradientLayer()
        layer.frame = backgroundCircle.bounds
        layer.colors = [UIColor(rgb: 0xC6F3FD).cgColor, UIColor(rgb: 0xB2CAFF).cgColor]
        layer.locations = [0.6, 1]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0.4, y: 1)
        backgroundCircle.layer.addSublayer(layer)
        view.addSubview(backgroundCircle)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.text = "Discover\nRestaurants"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 30, y: 60)
        view.addSubview(titleLabel)
        
        tableView = RestaurantsTableView(frame: CGRect(x: 32, y: 0, width: view.frame.width - 64, height: view.frame.height - 90))
        tableView.contentInset = UIEdgeInsets(top: (titleLabel.frame.maxY + 50), left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.tintColor = .gray
        searchButton.frame.size = CGSize(width: 25, height: 25)
        searchButton.center = CGPoint(x: view.frame.width - 40, y: titleLabel.frame.midY)
        view.addSubview(searchButton)
        
        let toolbar = RestaurantToolbar(frame: CGRect(x: 0, y: view.frame.height - 90, width: view.frame.width, height: 90))
        view.addSubview(toolbar)
    }


}

