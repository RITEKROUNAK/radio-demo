//
//  SettingsCells.swift
//  ShoppingList
//
//  Created by Dmitry Veleskevich on 1/3/20.
//  Copyright © 2020 Dmitry Veleskevich. All rights reserved.
//

import UIKit
import MessageUI

class Settings: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
         tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

    let adRemovalPurchased = UserDefaults.standard
    
    @IBAction func close(_ sender: UIBarButtonItem) {
      navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var cell: UITableViewCell!

    func reviewApp() {
        if let url = URL(string: "https://itunes.apple.com/app/id1518812350?action=write-review") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func shareApp() {
        let url = "https://itunes.apple.com/app/id1518812350"
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
      if let popoverController = vc.popoverPresentationController {
          popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
          popoverController.sourceView = self.view
          popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
      }

        present(vc, animated: true)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dmitryveleskevich@gmail.com"])
            mail.setSubject("Simple Radio")
            present(mail, animated: true)
        } else {
            showAlert(self)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func showAlert(_ sender: Any) {
        UIPasteboard.general.string = "dmitryveleskevich@gmail.com"
        let alertController = UIAlertController(title: "Feedback", message: "You can send me e-mail at dmitryveleskevich@gmail.com. It was copied in your clipboard.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1: switch indexPath.row {
              case 0: reviewApp()
              case 1: shareApp()
              case 2: sendEmail()
              default: break
              }
            case 2: switch indexPath.row {
                  case 0:                 let url = URL(string: "https://apps.apple.com/us/developer/dzmitry-veliaskevich/id1489322593")
                  if let url = url {
                      if UIApplication.shared.canOpenURL(url) {
                          UIApplication.shared.open(url)
                      }
                  }

                  default: break
                  }

        default: break
        }
    }

        }

