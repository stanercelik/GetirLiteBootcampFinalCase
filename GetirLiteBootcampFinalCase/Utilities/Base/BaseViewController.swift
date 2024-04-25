//
//  BaseViewController.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import UIKit

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in }
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}

