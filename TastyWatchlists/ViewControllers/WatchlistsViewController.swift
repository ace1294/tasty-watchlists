//
//  WatchlistsViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

class WatchlistsViewController: UITableViewController {
    
    var navigationDrawerController: NavigationDrawerViewController?
    
    var currentUser: User? {
        didSet {
            reloadData()
        }
    }
    var selectedWatchlist: Watchlist? {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.register(UINib(nibName: "ActivityCell", bundle:nil), forCellReuseIdentifier: "ActivityCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "ID")
        
        navigationDrawerController = NavigationDrawerViewController()
        if let navDrawer = navigationDrawerController {
            navDrawer.view.frame = CGRect(x: -view.frame.size.width*0.7, y: 0, width: view.frame.size.width*0.7, height: view.frame.size.height)
            view.addSubview(navDrawer.view)
            addChildViewController(navDrawer)
            navDrawer.didMove(toParentViewController: self)
            navDrawer.delegate = self
            navDrawer.dataSource = self
        }
        
        
        if let lists = currentUser?.watchlists {
            selectedWatchlist = lists[0]
        }
        
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            if let navDrawer = self.navigationDrawerController {
                navDrawer.reloadDataSource()
            }
            self.title = self.selectedWatchlist?.name
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didPressMenuButton(_ sender: UIButton) {
        navigationDrawerController?.toggleDrawer()
        
    }
    
    @IBAction func didPressDeleteButton(_ sender: UIButton) {
        if let list = selectedWatchlist, let name = list.name, let user = currentUser {
            let alert = UIAlertController(title: "Deleting Watchlist", message: "Are you sure youw ant to delete \(name) watchlist?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.deleteWatchlist(watchlist: list, user: user, success: { userWithoutList in
                    self.currentUser = userWithoutList
                    self.selectedWatchlist = userWithoutList.watchlists?.first
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showSearch, let searchVC = segue.destination as? SymbolSearchViewController {
            searchVC.delegate = self
        }
    }

}

// MARK: - TableViewDelegate

extension WatchlistsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}


//MARK: - TableViewDataSource

extension WatchlistsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let symbols = selectedWatchlist?.symbols {
            return symbols.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath) as UITableViewCell
        
        if let symbols = selectedWatchlist?.symbols, let name = symbols[indexPath.row].name{
            cell.textLabel?.text = name
        }
        
        return cell
    }
}

// MARK: - NavigationDrawerDataSource

extension WatchlistsViewController: NavigationDrawerDataSource {
    func userNameText(_ drawer: NavigationDrawerViewController) -> String {
        if let name = currentUser?.name {
            return name
        }
        else {
            return ""
        }
    }
    
    func numberOfRows(_ drawer: NavigationDrawerViewController) -> Int {
        if let lists = currentUser?.watchlists {
            return lists.count
        }
        else {
            return 0
        }
    }
    
    func textForRowAtIndex(_ drawer: NavigationDrawerViewController, index: Int) -> String{
        if let lists = currentUser?.watchlists, let name = lists[index].name {
            return name
        }
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if let user = currentUser, let list = selectedWatchlist, let symbolToDelete = list.symbols?[indexPath.row] {
                deleteSymbol(symbol: symbolToDelete, watchlist: list, user: user, success: { user, watchlistWithoutSymbol in
                    self.currentUser = user
                    self.selectedWatchlist = watchlistWithoutSymbol
                })
            }
            
        }
    }
}

// MARK: - NavigationDrawerDelegate

extension WatchlistsViewController: NavigationDrawerDelegate {
    func didSelectRowAtIndex(_ drawer: NavigationDrawerViewController, index: Int) {
        if let lists = currentUser?.watchlists {
            selectedWatchlist = lists[index]
            tableView.reloadData()
        }
    }
    
    func didSelectCreateNewWatchlist(_ drawer: NavigationDrawerViewController) {
        let alert = UIAlertController(title: "Create New Watchlist", message: "Enter a name", preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0], let text = textField.text, let user = self.currentUser {
                self.createWatchlist(user, name: text, success: { userWithWatchlist, newList in
                    self.selectedWatchlist = newList
                    self.currentUser = userWithWatchlist
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))

        present(alert, animated: true, completion: nil)
    }
    
    func didSelectLogout(_ drawer: NavigationDrawerViewController) {
        
    }
}


// MARK: API Interaction

extension WatchlistsViewController {
    
    func createWatchlist(_ user: User, name: String, success:@escaping (User, Watchlist) -> Void) {
        let watchlist = Watchlist(name: name)
        WatchlistManager.createWatchlist(watchlist, forUser: user, success: { newUser in
            if let newList = newUser.watchlists?.last {
                success(newUser, newList)
            }
            
        }) {
            print ("Failure")
        }
    }
    
    func deleteWatchlist(watchlist: Watchlist, user: User, success:@escaping (User) -> Void) {
        print ("deleteWatchlist()")
        
        WatchlistManager.deleteWatchlist(watchlist, forUser: user, success: { userWithoutList in
            success(userWithoutList)
        }) {
            print ("failure deleting list")
        }
        
    }
    
    func createSymbol(_ name: String, watchlist: Watchlist, user: User, success:@escaping (User, Watchlist) -> Void) {
        let symbol =  Symbol(name: name)
        
        WatchlistManager.addSymbolToWatchlist(symbol, watchlist: watchlist, forUser: user, success: { user, watchlistWithSymbol in
            success(user, watchlistWithSymbol)
        }) {
            print ("Failure in creating symbol")
        }
    }
    
    func deleteSymbol(symbol: Symbol, watchlist: Watchlist, user: User, success:@escaping (User, Watchlist) -> Void) {
        WatchlistManager.deleteSymbolFromWatchlist(symbol, watchlist: watchlist, forUser: user, success: { user, watchlistWithoutSymbol in
            success(user, watchlistWithoutSymbol)
        }) {
            print ("Failure in Deleting symbol")
        }
    }
    
}

// MARK: - SymbolSearchDelegate

extension WatchlistsViewController: SymbolSearchDelegate {
    func didSelectSymbol(_ symbol: TastySymbol) {
        if let watchlist = selectedWatchlist, let user = currentUser {
            createSymbol(symbol.shortName, watchlist: watchlist, user: user, success: { user, watchlistWithSymbol in
                self.currentUser = user
                self.selectedWatchlist = watchlistWithSymbol
            })
            
        }
        
    }
}
