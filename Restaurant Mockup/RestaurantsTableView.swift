//
//  RestaurantsTableView.swift
//  Restaurant Mockup
//
//  Created by Daniel Vebman on 10/22/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RestaurantsTableView: UITableView, UITableViewDataSource {
    var restaurants: [Restaurant] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        restaurants.append(Restaurant(name: "Island Burger", rating: 4.8, numberOfReviews: 1015, detail: "Modern yet classic American burger bar. Open until 1:00 on Saturdays.", image: #imageLiteral(resourceName: "hamburger")))
        restaurants.append(Restaurant(name: "Dos Caminos", rating: 4.0, numberOfReviews: 846, detail: "Hip and authentic spot under the High Line for Latin American tapas with a patio open until 12:00 AM.", image: #imageLiteral(resourceName: "tapas")))
        
        backgroundColor = .clear
        clipsToBounds = false
        separatorStyle = .none
        rowHeight = 300
        
        register(RestaurantsTableViewCell.self, forCellReuseIdentifier: "cell")
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantsTableViewCell
        let restaurant = restaurants[indexPath.row]
        cell.name = restaurant.name
        cell.rating = restaurant.rating
        cell.numberOfRatings = restaurant.numberOfReviews
        cell.detail = restaurant.detail
        cell.backgroundImage = restaurant.image
        return cell
    }
}

class RestaurantsTableViewCell: UITableViewCell {
    private var backgroundImageView = UIImageView()
    private var titleLabel = UILabel()
    private var ratingView = CosmosView()
    private var detailLabel = UILabel()
    private var directionsButton = UIButton()
    
    var name: String = "" {
        didSet {
            titleLabel.text = name
            layoutSubviews()
        }
    }
    
    var rating: Double = 0 {
        didSet {
            ratingView.rating = rating
        }
    }
    
    var numberOfRatings: Int = 0 {
        didSet {
            ratingView.text = "(\(numberOfRatings))"
        }
    }
    
    var detail: String = "" {
        didSet {
            detailLabel.text = detail
            layoutSubviews()
        }
    }
    
    var backgroundImage: UIImage = UIImage() {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = contentView.layer.cornerRadius
        backgroundImageView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        
        var starSettings = CosmosSettings()
        starSettings.emptyBorderColor = .lightGray
        starSettings.emptyColor = .lightGray
        starSettings.filledBorderColor = UIColor(rgb: 0xFFDF00)
        starSettings.starSize = 15
        starSettings.starMargin = 0
        starSettings.totalStars = 5
        starSettings.fillMode = .precise
        ratingView.settings = starSettings
        ratingView.isUserInteractionEnabled = false
        contentView.addSubview(ratingView)
        
        detailLabel.font = UIFont.systemFont(ofSize: 15)
        detailLabel.textColor = .gray
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
    }
    
    override var frame: CGRect {
        didSet {
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = 20
            layer.shadowOpacity = 0.3
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0))
        
        backgroundImageView.frame = contentView.bounds
        
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 30, y: 30)
        
        ratingView.frame.origin = CGPoint(x: 30, y: titleLabel.frame.maxY + 5)
        
        detailLabel.frame.size.width = contentView.frame.width - 60
        detailLabel.frame.size.height = detail.height(withConstrainedWidth: detailLabel.frame.width, font: detailLabel.font)
        detailLabel.frame.origin = CGPoint(x: 30, y: ratingView.frame.maxY + 10)
        
        backgroundImageView.layer.sublayers?.filter { $0.name == "fade" }.first?.removeFromSuperlayer()
        let gradient = CAGradientLayer()
        gradient.frame = backgroundImageView.bounds
        gradient.colors = [
            UIColor(white: 1, alpha: 0.9).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
        gradient.locations = [
            (detailLabel.frame.maxY - 10) / backgroundImageView.frame.height as NSNumber,
            1.0
        ]
        gradient.name = "fade"
        
        backgroundImageView.layer.insertSublayer(gradient, at: 0)
    }
}
