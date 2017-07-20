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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("Login View Controller ViewDidLoad")
    }
    
    @IBAction func didPressLoginToFacebook(_ sender: UIButton) {
        FacebookLoginManager.login(fromViewController: self, success: { user in
            guard let facebookId = user.facebookUserId else {
                return
            }
            
            UserManager.getUserWithFacebookId(facebookId, success: { completeUser in
                UserPersistence.storedUserId = completeUser.serverId
                self.transitionToWatchlist()
            }, failure: {
                print ("Failed get user with facebook id")
                UserManager.createUser(user, success: { completeNewUser in
                    UserPersistence.storedUserId = completeNewUser.serverId
                    self.transitionToWatchlist()
                }, failure: { 
                    print ("failed to create")
                })
            })
        }, failure: {
            //
        })
    }
    
    //MARK: Transitions
    
    func transitionToWatchlist() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.showWatchlists, sender: nil)
        }
    }

}
