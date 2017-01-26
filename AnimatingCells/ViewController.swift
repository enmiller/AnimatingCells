//
//  ViewController.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/25/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AnimatingMenuViewControllerDelegate {

    @IBAction func presentMenu(_ sender: UIButton) {
        let animatingMenuController = AnimatingMenuViewController()
        animatingMenuController.delegate = self
        animatingMenuController.modalTransitionStyle = .crossDissolve
        animatingMenuController.modalPresentationStyle = .overCurrentContext
        
        animatingMenuController.strings = ["First", "Second", "Third", "Fourth"]
        
        present(animatingMenuController, animated: false, completion: nil)
    }
    
    // MARK: - AnimatingMenuViewControllerDelegate
    func animatingMenuController(_ animatingController: AnimatingMenuViewController, didSelect string: String) {
        self.dismiss(animated: false, completion: nil)
    }
}

