//
//  AnimatingMenuView.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/25/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

// Not optimized for storyboard usage.
class AnimatingMenuView: UIView {
    
    private(set) var tableView: UITableView
    
    public override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableView = UITableView()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
        
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.alpha = 0.0
        addSubview(tableView)
    }
    
    // MARK: - Actions
    func configureTableView() {
        // Would not be needed in a storyboard.
        tableView.frame = self.bounds
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
                withDuration: 0.2,
                animations: {
                    self.tableView.alpha = 1.0
            }, completion: { (completed) in
                let delay: TimeInterval = 0.15
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
                        withDuration: 0.4,
                        delay: (delay * Double(index)),
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 0.4,
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
            let delay: TimeInterval = 0.15
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
                    withDuration: 0.25,
                    delay: (delay * Double(index)),
                    usingSpringWithDamping: 1.0,
                    initialSpringVelocity: 0.5,
                    options: [],
                    animations: {
                        cell.frame = offscreenFrame
                }, completion: { (completed) in
                        dGroup.leave()
                })
            }
            
            dGroup.notify(queue: DispatchQueue.main) {
                UIView.animate(
                    withDuration: 0.2,
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
}
