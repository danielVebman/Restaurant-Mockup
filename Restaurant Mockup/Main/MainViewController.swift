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
    /// Animation state variables
    var isShowingTitle = false
    var isHidingTitle = false
    var isShowingBlur = false
    var isHidingBlur = false
    
    var backgroundCircle: UIView!
    var titleLabel: UILabel!
    var searchButton: UIButton!
    var tableView: RestaurantsTableView!
//    var collectionView: RestaurantsCollectionView!
//    var reservationsButton: SquishButton!
    var timeBlurView: UIVisualEffectView!
    
    var restaurants: [Restaurant] = []
    
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

        restaurants = [
            Restaurant(name: "Island Burger", rating: 4.8, numberOfReviews: 1015, detail: "Modern yet classic American burger bar. Open until 1:00 on Saturdays.", image: #imageLiteral(resourceName: "hamburger"), address: "422 Amsterdam Ave"),
            Restaurant(name: "Dos Caminos", rating: 4.0, numberOfReviews: 846, detail: "Hip and authentic spot under the High Line for Latin American tapas with a patio open until 12:00 AM.", image: #imageLiteral(resourceName: "tapas"), address: "675 Hudson St"),
            Restaurant(name: "Boulud Sud", rating: 4.5, numberOfReviews: 348, detail: "Refined Mediterranean dining via chef Daniel Boulud with convenience to Lincoln Center.", image: #imageLiteral(resourceName: "harira"), address: "20 W 64th St")
        ]
        
        tableView = RestaurantsTableView(frame: CGRect(x: 32, y: 0, width: view.frame.width - 64, height: view.frame.height - 90), restaurants: restaurants)
        tableView.contentInset = UIEdgeInsets(top: (titleLabel.frame.maxY + 50), left: 0, bottom: 20, right: 0)
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        view.addSubview(tableView)
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.tintColor = .gray
        searchButton.frame.size = CGSize(width: 25, height: 25)
        searchButton.center = CGPoint(x: view.frame.width - 40, y: titleLabel.frame.midY)
        view.addSubview(searchButton)
        
        let toolbar = RestaurantToolbar(frame: CGRect(x: 0, y: view.frame.height - 90, width: view.frame.width, height: 90))
        view.addSubview(toolbar)
        
        timeBlurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height))
        view.addSubview(timeBlurView)
        
        /*
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        collectionView = RestaurantsCollectionView(frame: frame, restaurants: restaurants)
        collectionView.center.y = (toolbar.frame.origin.y + titleLabel.frame.maxY) * 2 / 5
        view.addSubview(collectionView)
        */
        
        /*
        reservationsButton = SquishButton(type: .roundedRect)
        reservationsButton.frame = CGRect(x: view.frame.midX - 100, y: (toolbar.frame.origin.y + collectionView.frame.maxY) / 2 - 25, width: 200, height: 50)
        reservationsButton.layer.borderColor = UIColor(rgb: 0x4286f4).cgColor
        reservationsButton.color = UIColor(rgb: 0x4286f4)
        reservationsButton.setTitle("MY RESERVATIONS", for: .normal)
        view.addSubview(reservationsButton)
        */
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueInfo = (tableView.cellForRow(at: indexPath) as! RestaurantsTableViewCell).segueInfo
        present(DetailViewController(segueInfo: segueInfo), animated: false, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.contentInset.top > 160 {
            if timeBlurView.effect == nil && !isShowingBlur {
                // show
                isShowingBlur = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.timeBlurView.effect = UIBlurEffect(style: .light)
                }) { (_) in
                    self.isShowingBlur = false
                }
            }
        } else {
            if timeBlurView.effect != nil && !isHidingBlur {
                // hide
                isHidingBlur = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.timeBlurView.effect = nil
                }) { (_) in
                    self.isHidingBlur = false
                }
            }
        }
        
        if scrollView.contentOffset.y + scrollView.contentInset.top > 50 {
            if titleLabel.alpha > 0 && !isHidingTitle {
                // hide
                isHidingTitle = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.titleLabel.alpha = 0
                    self.titleLabel.frame.origin.y -= 5
                    self.searchButton.alpha = 0
                    self.searchButton.frame.origin.y -= 5
                }) { (_) in
                    self.isHidingTitle = false
                }
            }
        } else {
            if titleLabel.alpha < 1 && !isShowingTitle {
                // show
                isShowingTitle = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.titleLabel.alpha = 1
                    self.titleLabel.frame.origin.y += 5
                    self.searchButton.alpha = 1
                    self.searchButton.frame.origin.y += 5
                }) { (_) in
                    self.isShowingTitle = false
                }
            }
        }
    }
}

