//
//  LaunchViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let storedUserId = UserPersistence.storedUserId {
            UserManager.getUserWithServerId(storedUserId, success: { user in
                UserPersistence.storedUserId = user.serverId
                self.user = user
                self.transitionToWatchlist()
            }, failure: {
                self.transitionToLogin()
            })
        }
        else {
            transitionToLogin()
        }
    }
    
    //MARK: Transitions
    
    func transitionToWatchlist() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.showWatchlists, sender: nil)
        }
    }
    
    func transitionToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.showLogin, sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showWatchlists {
            if let navController = segue.destination as? UINavigationController, let watchlistVC = navController.topViewController as? WatchlistsViewController {
                watchlistVC.currentUser = self.user
                
            }
        }
    }


}
