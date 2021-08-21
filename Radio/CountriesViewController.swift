//
//  CountriesViewController.swift
//  Radio
//
//  Created by Dmitry Veleskevich on 6/14/20.
//  Copyright © 2020 Dzmitry Veliaskevich. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController, UISearchResultsUpdating, UINavigationControllerDelegate {

    var resultSearchController = UISearchController()

    var filteredTableData = [String]()

    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (countries as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]

        self.tableView.reloadData()
    }

        func registerDefaults() {
        let dictionary = ["Index": -1, "FirstTime": true ] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
        }

        var indexOfSelectedChecklist: Int {
        get {
        return UserDefaults.standard.integer(forKey: "Index")
        } set {
        UserDefaults.standard.set(newValue, forKey: "Index")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.delegate = self
    let index = indexOfSelectedChecklist
    if index >= 0 && index < countries.count {
    let checklist = countries[index]
    performSegue(withIdentifier: "ShowStation", sender: checklist)
        }
    }

        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
        indexOfSelectedChecklist = -1
        }
    }

    var countries = ["United States", "United Kingdom", "Germany", "France", "Colombia", "Brasil", "Spain", "Mexico", "Argentina", "Italia", "Canada", "Netherlands", "Chile", "Turkey", "Indonesia", "Ecuador", "Australia", "Romania", "Venezuela", "Dominicana", "Poland", "Portugal", "Peru", "Switzerland", "Haiti", "Serbia", "Guatemala", "India", "Nepal", "South Africa", "Philippines", "Hungary", "Ghana", "Austria", "Croatia", "Sweden", "Malaysia", "Ireland", "Uruguay", "Bosnia and Herzegovina", "Paraguay", "El Salvador", "Danmark", "Honduras", "New Zealand", "Norway", "Puerto Rico", "Czech Republic", "Costa Rica", "Belgium", "Bolivia", "Nigeria", "Israel", "Pakistan", "Panama", "Sri Lanka", "North Macedonia", "Thailand", "Albania", "Kenya", "Slovenia", "Lebanon", "Senegal", "Nicaragua", "Lithuania", "Tanzania", "Slovakia", "Uganda", "Morocco", "Estonia", "Egypt", "Montenegro"]

    override func viewDidLoad() {

        registerDefaults()

         tableView.backgroundView = UIImageView(image: UIImage(named: "background"))

        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            //controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barTintColor = UIColor.clear
            controller.searchBar.tintColor = UIColor.white

            tableView.tableHeaderView = controller.searchBar

            tableView.setContentOffset(CGPoint(x: 0.0, y: controller.searchBar.frame.size.height), animated: false)
            // iOS 13 or greater
            if  ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0)) {
                // Make text readable in black searchbar
                controller.searchBar.barStyle = .black
                // Set a black keyborad for UISearchController's TextField
                if #available(iOS 13.0, *) {
                    let searchTextField = controller.searchBar.searchTextField
                    searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
                } else {
                    // Fallback on earlier versions
                }
            } else {
                let searchTextField = controller.searchBar.value(forKey: "_searchField") as! UITextField
                searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
            }


            return controller
        })()

        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return countries.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Countries", for: indexPath)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        }
        else {
            cell.textLabel?.text = countries[indexPath.row]
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = countries[indexPath.row]
    performSegue(withIdentifier: "ShowStation", sender: item)
    tableView.deselectRow(at: indexPath, animated: true)
    indexOfSelectedChecklist = indexPath.row
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowStation" {
          let controller = segue.destination as! StationsViewController
        controller.country = sender as! String
          }
    }
}

