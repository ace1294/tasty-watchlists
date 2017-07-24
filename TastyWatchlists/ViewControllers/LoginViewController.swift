//
//  LoginViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/19/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class LoginViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didPressLoginToFacebook(_ sender: UIButton) {
        FacebookLoginManager.login(fromViewController: self, success: { user in
            guard let facebookId = user.facebookUserId else {
                return
            }
            UserManager.getUserWithFacebookId(facebookId, success: { completeUser in
                UserPersistence.storedUserId = completeUser.serverId
                self.user = completeUser
                self.transitionToWatchlist()
            }, failure: {
                UserManager.createUser(user, success: { completeNewUser in
                    UserPersistence.storedUserId = completeNewUser.serverId
                    self.user = completeNewUser
                    self.transitionToWatchlist()
                }, failure: { 
                    print ("Failed to create User")
                })
            })
        }, failure: {
            print ("Failed facebook login")
        })
    }
    
    //MARK: Transitions
    
    func transitionToWatchlist() {
        print ("Trying to transitioning to watchlsit")
        DispatchQueue.main.async {
            print ("transitioning to watchlsit")
            self.performSegue(withIdentifier: Segues.showWatchlists, sender: nil)
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
