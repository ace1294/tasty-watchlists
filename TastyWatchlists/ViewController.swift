//
//  ViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/17/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    static let serverUrl = "http://198.199.81.13:8080/"
    static let serverUrl = "http://localhost:8080/"

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    @IBAction func makeRequest(_ sender: UIButton) {
//        createUser()
        getUser { user in
//            if let firstList = user.watchlists?.first {
//                self.deleteWatchlist(watchlist: firstList, user: user)
//                if let firstSymbol = firstList.symbols?.first {
//                    self.deleteSymbol(symbol: firstSymbol, watchlist: firstList, user: user)
//                }
//                self.createSymbol(watchlist: firstList, user: user)
//            }
            
            self.createWatchlist(user: user)
            
            
            
        }
        
    }
    
    func getUser(success:@escaping (User) -> Void) {
        UserManager.getUserWithFacebookId("700070-wodp2000-wqqoap222", success: { user in
            print ("successfully got user \(user.toDictionary())")
            success(user)
        }) { 
            print ("failed getting user")
        }
    }
    
    func createUser () {
        let user = User(name: "Jon Dimitriou", facebookId: "700070-wodp2000-wqqoap222")
        UserManager.createUser(user, success: { newUser in
            print ("Success \(newUser.toDictionary())")
        }) { 
            print ("Failure")
        }
    }
    
    func createWatchlist (user: User) {
        let watchlist = Watchlist(name: "Boring Stocks")
        WatchlistManager.createWatchlist(watchlist, forUser: user, success: { newUser in
            print ("Success \(newUser.toDictionary())")
        }) {
            print ("Failure")
        }
    }
    
    func deleteWatchlist (watchlist: Watchlist, user: User) {
        print ("deleteWatchlist()")
        
        WatchlistManager.deleteWatchlist(watchlist, forUser: user, success: { newUser in
            print ("Successfully deleted list \(newUser.toDictionary())")
        }) { 
            print ("failure deleting list")
        }
        
    }
    
    func createSymbol (watchlist: Watchlist, user: User) {
        print ("createSymbol()")
        let symbol =  Symbol(name: "HD")
        
        WatchlistManager.addSymbolToWatchlist(symbol, watchlist: watchlist, forUser: user, success: { newUser in
            print ("Successfully created symbol \(newUser.toDictionary())")
        }) { 
            print ("Failure in creating symbol")
        }
    }
    
    func deleteSymbol (symbol: Symbol, watchlist: Watchlist, user: User) {
        print ("deleteSymbol()")
        WatchlistManager.deleteSymbolFromWatchlist(symbol, watchlist: watchlist, forUser: user, success: { newUser in
            print ("Successfully deleted list \(newUser.toDictionary())")
        }) {
            print ("Failure in creating symbol")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

