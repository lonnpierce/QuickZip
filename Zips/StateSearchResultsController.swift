//
//  StateSearchResultsController.swift
//  Zips
//
//  Created by Lonnie Pierce on 7/1/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import UIKit

class StateSearchResultsController: UITableViewController, UISearchResultsUpdating{
    
    private let filteredStateCell = "FilteredStateName"
     
    @IBOutlet var statesTableView: UITableView!
    var filteredState = [String]()
    var states = [String: [String]]()
    var keys = [String]()
    var isSearchActive = false
    
    @IBOutlet weak var stateSearchTableView: UINavigationItem!
    
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: filteredStateCell)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: filteredStateCell)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = filteredState[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        

        let nav = UIStoryboard(name: "ZipsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StatesVC") as! RootViewControllerTableViewController
        let cell = tableView.cellForRow(at: indexPath)
        //Prepare CityViewController for Segue
        let cityVC:CityViewController = UIStoryboard(name: "ZipsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cityVC") as! CityViewController
        //let navVc = stateSearchTableView.self().
        //navVc.addChildViewController(cityVC)
        //navVc.pushViewController(cityVC, animated: false)
       //
       // navVC.show(cityVC, sender: nil)
        //let segue = UIStoryboardSegue(identifier: "cityVCSegue", source: cityVC, destination: navVC)
        //navVC?.addChildViewController(cityVC)
        //navVC.show(cityVC, sender: self)
               //let stateVC:RootViewControllerTableViewController = UIStoryboard(name: "ZipsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StateVC") as! RootViewControllerTableViewController
       // stateVC.show(cityVC, sender: nil)
         //let segue = UIStoryboardSegue(identifier: "cityVCSegue", source: stateVC, destination: cityVC)
        // self.prepare(for: segue, sender: nil)
       //let rootVC = UINavigationController.init(rootViewController: self)
        
    
        cityVC.State = filteredState[indexPath.row]
        cityVC.title = "Cities"
      //  cityVC.navigationItem.backBarButtonItem = UIBarButtonItem.
        nav.performSegue(withIdentifier: "cityVCSegue", sender: cell as Any)
       // self.un
        //navVC.loadView()
        //navVC.show(cityVC, sender: nil)
        
 
        
        //cityNavVC.
        //self.addChildViewController(cityVC)
         //self.navigationController?.performSegue(withIdentifier: "cityVCSegue", sender: self)
    
        
 
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if filteredState.count == 0
        {
            return 0
        }
        else{
            return 1
        }
        
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return filteredState.count
          }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filteredState.removeAll(keepingCapacity: true)
        
        if (!(searchText?.isEmpty)! && filteredState.count == 0) {
            
            isSearchActive = true
            //let startIndex = searchText?.index((searchText?.startIndex)!, offsetBy: 1)
           // let key = keys.filter{$0.contains(startIndex as! String)} as! String
            //states[key] = states[key]
            
           for key in keys {
                let stateForKey = states[key]!
                let matches = stateForKey.filter{ $0.contains(searchText!)} as [String]
                filteredState += matches
                //if key == initalIndex {
                  //  break
                //}
            }
            tableView.reloadData()
        }
        else {
            isSearchActive = false
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
       // let key = keys[(indexPath?.section)!]
        //let stateSection = states[key]!
        let state = keys[1]
        let cityVC = segue.destination as! CityViewController
        cityVC.State = state;
        
        
        
    }
  

}
