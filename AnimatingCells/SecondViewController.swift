//
//  SecondViewController.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/26/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, AnimatingMenuViewControllerDelegate {
    
    @IBAction func presentMenu(_ sender: UIButton) {
        let animatingMenuController = AnimatingMenuViewController()
        animatingMenuController.delegate = self
        animatingMenuController.strings = ["Presenting", "Menu", "with", "manual", "initialization"]
        
        present(animatingMenuController, animated: false, completion: nil)
    }

    // MARK: - AnimatingMenuViewControllerDelegate
    func animatingMenuController(_ animatingController: AnimatingMenuViewController, didSelect string: String) {
        self.dismiss(animated: false, completion: nil)
    }
}
