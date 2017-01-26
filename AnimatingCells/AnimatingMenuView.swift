//
//  AnimatingMenuView.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/25/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

class AnimatingMenuView: UIView {
    
    @IBOutlet private(set) var tableView: UITableView!
    @IBInspectable var backgroundFadeDuration: Double = 0.2
    @IBInspectable var animationDelayBetweenCells: Double = 0.1
    
    // Presentation
    @IBInspectable var animationPresentationDuration: Double = 0.4
    /**
     - Note: Setting this property to a value greater
     than 1.0 will implicitly reset the value back to 1.0. A value less 
     than 0.0, the value will be reset to 0.0.
     */
    @IBInspectable var presentationSpringDamping: CGFloat = 0.6
    
    /**
     - Note: Setting this property to a value greater
     than 1.0 will implicitly reset the value back to 1.0. A value less
     than 0.0, the value will be reset to 0.0.
     */
    @IBInspectable var presentationInitialVelocity: CGFloat = 0.4
    
    // Dismiss
    @IBInspectable var animationDismissDuration: Double = 0.2
    /**
     - Note: Setting this property to a value greater
     than 1.0 will implicitly reset the value back to 1.0. A value less
     than 0.0, the value will be reset to 0.0.
     */
    @IBInspectable var dismissSpringDamping: CGFloat = 1.0
    
    /**
     - Note: Setting this property to a value greater
     than 1.0 will implicitly reset the value back to 1.0. A value less
     than 0.0, the value will be reset to 0.0.
     */
    @IBInspectable var dismissInitialVelocity: CGFloat = 0.6
    
    public override init(frame: CGRect) {
        tableView = UITableView(frame: frame)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        configureTableView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    func refineTableViewLayout(with frame: CGRect? = nil) {
        if let frame = frame {
            tableView.frame = frame
        } else {
            tableView.frame = self.bounds
        }
    }
    
    func presentMenu(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        tableView.reloadData()
        if animated {
            
            let visibleCells = tableView.visibleCells
            for cell in visibleCells {
                let offscreenFrame = CGRect(
                    x: tableView.frame.width,
                    y: cell.frame.origin.y,
                    width: cell.frame.width,
                    height: cell.frame.height
                )
                cell.frame = offscreenFrame
            }
            UIView.animate(
                withDuration: backgroundFadeDuration,
                animations: {
                    self.tableView.alpha = 1.0
            }, completion: { (completed) in
                let dGroup = DispatchGroup()
                for (index, cell) in visibleCells.enumerated() {
                    let newFrame = CGRect(
                        x: 0.0,
                        y: cell.frame.origin.y,
                        width: cell.frame.width,
                        height: cell.frame.height
                    )
                    dGroup.enter()
                    UIView.animate(
                        withDuration: self.animationPresentationDuration,
                        delay: (self.animationDelayBetweenCells * Double(index)),
                        usingSpringWithDamping: self.presentationSpringDamping,
                        initialSpringVelocity: self.presentationInitialVelocity,
                        options: [],
                        animations: {
                            cell.frame = newFrame
                    },
                        completion: { (completed) in
                            dGroup.leave()
                    })
                }
                
                dGroup.notify(queue: DispatchQueue.main) {
                    completion?(completed)
                }
            })
        }
    }
    
    func dismissMenu(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if animated {
            let visibleCells = tableView.visibleCells
            let dGroup = DispatchGroup()
            for (index, cell) in visibleCells.enumerated() {
                let offscreenFrame = CGRect(
                    x: tableView.frame.width,
                    y: cell.frame.origin.y,
                    width: cell.frame.width,
                    height: cell.frame.height
                )
                dGroup.enter()
                UIView.animate(
                    withDuration: animationDismissDuration,
                    delay: (animationDelayBetweenCells * Double(index)),
                    usingSpringWithDamping: dismissSpringDamping,
                    initialSpringVelocity: dismissInitialVelocity,
                    options: [],
                    animations: {
                        cell.frame = offscreenFrame
                }, completion: { (completed) in
                        dGroup.leave()
                })
            }
            
            dGroup.notify(queue: DispatchQueue.main) {
                UIView.animate(
                    withDuration: self.backgroundFadeDuration,
                    delay: 0.0,
                    options: [],
                    animations: {
                        self.tableView.alpha = 0.0
                }, completion: { (completed) in
                        completion?(completed)
                })
            }
        }
    }
    
    // MARK: - Private
    fileprivate func configureTableView() {
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.alpha = 0.0
        addSubview(tableView)
    }
}
