//
//  BuyScreen.swift
//  ShoppingList
//
//  Created by Dmitry Veleskevich on 1/3/20.
//  Copyright © 2020 Dmitry Veleskevich. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class BuyScreen: UIViewController {
    
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var oneTime: UIButton!
    

    @IBAction func oneTime(_ sender: UIButton) {
        SwiftyStoreKit.purchaseProduct("simple_radio_one_time_purchase", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults.standard.set(true, forKey: "purchased")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }

    }
    
    @IBAction func restorePurchases(_ sender: UIButton) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                UserDefaults.standard.set(true, forKey: "purchased")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftyStoreKit.retrieveProductsInfo(["simple_radio_one_time_purchase"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.oneTime.setTitle("\(priceString) one time", for: .normal)
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Terms" {
    let controller = segue.destination as! TermsPrivacy
    controller.receivedString = "https://veleskevich.com/terms-of-use/"
    } else if segue.identifier == "Privacy" {
    let controller = segue.destination as! TermsPrivacy
    controller.receivedString = "https://veleskevich.com/privacy-policy/"
        }
    }

}
