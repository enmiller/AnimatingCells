//
//  AnimatingMenuViewController.swift
//  AnimatingCells
//
//  Created by Eric Miller on 1/25/17.
//  Copyright © 2017 Tiny Zepplin. All rights reserved.
//

import UIKit

protocol AnimatingMenuViewControllerDelegate: class {
    func animatingMenuController(_ animatingController: AnimatingMenuViewController, didSelect string: String)
}

class AnimatingMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: AnimatingMenuViewControllerDelegate?
    
    var strings: [String]? {
        didSet {
            if isViewLoaded {
                animatingView().presentMenu(animated: true)
            }
        }
    }

    override func loadView() {
        let aView = AnimatingMenuView()
        aView.tableView.dataSource = self
        aView.tableView.delegate = self
        self.view = aView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animatingView().configureTableView()
    }

    fileprivate func animatingView() -> AnimatingMenuView {
        return viewIfLoaded as! AnimatingMenuView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if strings != nil {
            animatingView().presentMenu(animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = strings?[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let strings = strings else {
            preconditionFailure("Developer Error: data source is empty.")
        }
        
        animatingView().dismissMenu(animated: true) { (completed) in
            self.delegate?.animatingMenuController(self, didSelect: strings[indexPath.row])
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}
