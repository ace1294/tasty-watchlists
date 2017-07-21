//
//  NavigationDrawerViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

protocol NavigationDrawerDataSource {
    func userNameText(_ drawer: NavigationDrawerViewController) -> String
    func numberOfRows(_ drawer: NavigationDrawerViewController) -> Int
    func textForRowAtIndex(_ drawer: NavigationDrawerViewController, index: Int) -> String
}

protocol NavigationDrawerDelegate {
    func didSelectRowAtIndex(_ drawer: NavigationDrawerViewController, index: Int)
    func didSelectCreateNewWatchlist(_ drawer: NavigationDrawerViewController)
    func didSelectLogout(_ drawer: NavigationDrawerViewController)
}

class NavigationDrawerViewController: UIViewController {
    
    var dataSource: NavigationDrawerDataSource? {
        didSet {
            reloadDataSource()
        }
    }
    var delegate: NavigationDrawerDelegate?
    var drawerShown = false
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static fileprivate let cellReuseId = "cellReuseId"
    
    convenience init() {
        self.init(nibName:"NavigationDrawerViewController", bundle:Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NavigationDrawerViewController.cellReuseId)
        
        reloadDataSource()
    }

    func reloadDataSource () {
        userNameLabel.text = dataSource?.userNameText(self)
        tableView.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction fileprivate func didPressCreateWatchlist(_ sender: UIButton) {
        delegate?.didSelectCreateNewWatchlist(self)
        hideDrawer()
    }
    
    @IBAction fileprivate func didPressLogout(_ sender: UIButton) {
        delegate?.didSelectLogout(self)
        hideDrawer()
    }
    
    func toggleDrawer () {
        if drawerShown {
            hideDrawer()
        }
        else {
            showDrawer()
        }
    }

    fileprivate func showDrawer() {
        animateXPosition(targetPosition: 0.0)
        drawerShown = true
    }
    
    fileprivate func hideDrawer() {
        animateXPosition(targetPosition: -view.frame.size.width)
        drawerShown = false
    }
    
    fileprivate func animateXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.frame.origin.x = targetPosition
            }, completion: completion)
        }
    }

}

extension NavigationDrawerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = dataSource?.numberOfRows(self) {
            return rows
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationDrawerViewController.cellReuseId, for: indexPath) as UITableViewCell
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        if let text = dataSource?.textForRowAtIndex(self, index: indexPath.row) {
            cell.textLabel?.text = text
        }
        else {
            cell.textLabel?.text = "DATA SOURCE NEEDS TEXT FOR ROW \(indexPath.row)"
        }
        
        return cell
    }
}

extension NavigationDrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAtIndex(self, index: indexPath.row)
        hideDrawer()
    }
}
