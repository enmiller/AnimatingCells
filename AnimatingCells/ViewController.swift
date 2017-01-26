//
//  ViewController.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/25/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AnimatingMenuViewControllerDelegate {
    
    enum SegueConstants: String {
        case showMenu
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            preconditionFailure("Unrecognized segue identifier")
        }
        if let menuSegue = SegueConstants(rawValue: identifier) {
            let destination = segue.destination
            switch menuSegue {
            case .showMenu:
                if let animatingMenuController = destination as? AnimatingMenuViewController {
                    animatingMenuController.delegate = self
                    animatingMenuController.strings = ["Presenting", "Menu", "With", "Segue"]
                }
            }
        }
    }
    
    // MARK: - AnimatingMenuViewControllerDelegate
    func animatingMenuController(_ animatingController: AnimatingMenuViewController, didSelect string: String) {
        self.dismiss(animated: false, completion: nil)
    }
}

