//
//  RestaurantsCollectionView.swift
//  Restaurant Mockup
//
//  Created by Daniel Vebman on 2/4/19.
//  Copyright © 2019 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RestaurantsCollectionView: UICollectionView {
    var restaurants: [Restaurant]
    
    init(frame: CGRect, restaurants: [Restaurant]) {
        self.restaurants = restaurants
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        layout.itemSize = CGSize(width: frame.width - 50, height: frame.height - 50)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        dataSource = self
        
        clipsToBounds = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RestaurantsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RestaurantCollectionViewCell
        cell.restaurant = restaurants[indexPath.item]
        return cell
    }
}

class RestaurantCollectionViewCell: UICollectionViewCell {
    private var backgroundImageView = UIImageView()
    private var titleLabel = UILabel()
    private var ratingView = CosmosView()
    private var detailLabel = UILabel()
    private var directionsButton = UIButton()
    private var menuButton = UIButton()
    
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            
            titleLabel.text = restaurant.name
            ratingView.rating = restaurant.rating
            ratingView.text = "(\(restaurant.numberOfReviews))"
            detailLabel.text = restaurant.detail
            let addressWithChevron = NSMutableAttributedString(string: restaurant.address, attributes: [.foregroundColor: UIColor.black])
            addressWithChevron.append(NSAttributedString(string: "  \u{f054}", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "FontAwesome", size: 8)!]))
            directionsButton.setAttributedTitle(addressWithChevron, for: .normal)
            backgroundImageView.image = restaurant.image
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowRadius = 10
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    
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
        
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        directionsButton.setTitleColor(.black, for: .normal)
        directionsButton.frame.size.height = 35
        directionsButton.backgroundColor = .white
        directionsButton.layer.cornerRadius = 0.5 * directionsButton.frame.height
        directionsButton.layer.shadowColor = UIColor.lightGray.cgColor
        directionsButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        directionsButton.layer.shadowRadius = 20
        directionsButton.layer.shadowOpacity = 0.3
        directionsButton.layer.masksToBounds = false
        contentView.addSubview(directionsButton)
        
        menuButton.frame.size = CGSize(width: 50, height: 50)
        menuButton.frame.origin.x = 20
        menuButton.backgroundColor = .white
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        menuButton.tintColor = .black
        menuButton.layer.cornerRadius = 0.5 * menuButton.frame.height
        menuButton.layer.shadowColor = UIColor.lightGray.cgColor
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        menuButton.layer.shadowRadius = 20
        menuButton.layer.shadowOpacity = 0.8
        menuButton.layer.masksToBounds = false
        contentView.addSubview(menuButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0))
        
        backgroundImageView.frame = contentView.bounds
        
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: menuButton.frame.maxY + 10, y: 30)
        
        ratingView.frame.origin = CGPoint(x: menuButton.frame.maxY + 10, y: titleLabel.frame.maxY + 5)
        
        menuButton.center.y = (titleLabel.frame.minY + ratingView.frame.maxY) / 2
        
        detailLabel.frame.origin.x = menuButton.frame.maxY + 10
        detailLabel.frame.size.width = contentView.frame.width - 30 - detailLabel.frame.origin.x
        detailLabel.frame.size.height = restaurant?.detail.height(withConstrainedWidth: detailLabel.frame.width, font: detailLabel.font) ?? 0
        detailLabel.frame.origin.y = ratingView.frame.maxY + 10
        
        directionsButton.frame.size.width = (directionsButton.titleLabel!.text?.width(withConstrainedHeight: directionsButton.frame.height, font: directionsButton.titleLabel!.font) ?? 0) + 30
        directionsButton.center = CGPoint(x: contentView.frame.width / 2, y: contentView.frame.height)
        
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

