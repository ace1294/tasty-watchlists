//
//  LaunchViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let storedUserId = UserPersistence.storedUserId {
            UserManager.getUserWithServerId(storedUserId, success: { completeUser in
                UserPersistence.storedUserId = completeUser.serverId
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


}
