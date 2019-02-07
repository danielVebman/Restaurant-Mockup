//
//  DetailViewController.swift
//  Restaurant Mockup
//
//  Created by Daniel Vebman on 2/5/19.
//  Copyright © 2019 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class DetailViewController: UIViewController {
    private var contentView: UIView!
    private var backgroundImageView: UIImageView!
    private var titleLabel: UILabel!
    private var ratingView: CosmosView!
    private var detailLabel: UILabel!
    private var directionsButton: UIButton!
    private var menuButton: UIButton!
    
    init(segueInfo: SegueInfo) {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = .clear
        
        contentView = UIView(frame: segueInfo.cellFrame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)))
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        view.addSubview(contentView)
        
        backgroundImageView = UIImageView(frame: segueInfo.backgroundImageViewFrame)
        backgroundImageView.image = segueInfo.restaurant.image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = contentView.layer.cornerRadius
        backgroundImageView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)
        
        titleLabel = UILabel(frame: segueInfo.titleLabelFrame)
        titleLabel.text = segueInfo.restaurant.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        
        ratingView = CosmosView(frame: segueInfo.ratingViewFrame)
        ratingView.rating = segueInfo.restaurant.rating
        ratingView.text = "(\(segueInfo.restaurant.numberOfReviews))"
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
        
        detailLabel = UILabel(frame: segueInfo.detailLabelFrame)
        detailLabel.text = segueInfo.restaurant.detail
        detailLabel.font = UIFont.systemFont(ofSize: 15)
        detailLabel.textColor = .gray
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        
        directionsButton = UIButton(frame: segueInfo.directionsButtonFrame)
        let addressWithChevron = NSMutableAttributedString(string: segueInfo.restaurant.address, attributes: [.foregroundColor: UIColor.black])
        addressWithChevron.append(NSAttributedString(string: "  \u{f054}", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "FontAwesome", size: 8)!]))
        directionsButton.setAttributedTitle(addressWithChevron, for: .normal)
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
        directionsButton.frame = contentView.convert(directionsButton.frame, to: view)
        view.addSubview(directionsButton)
        
        menuButton = UIButton(frame: segueInfo.menuButtonFrame)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // transition to new frames
        
        let newFade = UIView(frame: self.backgroundImageView.bounds)
        newFade.alpha = 0
        newFade.backgroundColor = UIColor(white: 1, alpha: 0.8)
        backgroundImageView.addSubview(newFade)
        
        UIView.animate(withDuration: 0.5) {
            self.view.frame = UIScreen.main.bounds
            self.contentView.frame = UIScreen.main.bounds
            self.contentView.layer.cornerRadius = 0
            
            self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250)
            self.backgroundImageView.layer.cornerRadius = 0
            self.backgroundImageView.layer.sublayers!.first(where: { $0.name == "fade" })!.opacity = 0
            
            newFade.alpha = 1
            newFade.frame = self.backgroundImageView.bounds
            
            self.titleLabel.textAlignment = .center
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.titleLabel.center = self.backgroundImageView.center
            self.titleLabel.center.y += UIApplication.shared.statusBarFrame.height / 2
            
            self.detailLabel.frame = CGRect(x: 20, y: self.backgroundImageView.frame.maxY, width: self.view.frame.width - 40, height: 100)
            
            self.ratingView.alpha = 0
            self.directionsButton.alpha = 0
            self.menuButton.alpha = 0
        }
    }
}

struct SegueInfo {
    var restaurant: Restaurant
    
    var cellFrame: CGRect
    var backgroundImageViewFrame: CGRect
    var titleLabelFrame: CGRect
    var ratingViewFrame: CGRect
    var detailLabelFrame: CGRect
    var directionsButtonFrame: CGRect
    var menuButtonFrame: CGRect
}
