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
    fileprivate var manuallyInitialized: Bool = false
    
    var strings: [String]? {
        didSet {
            if isViewLoaded {
                animatingView().presentMenu(animated: true)
            }
        }
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.manuallyInitialized = true
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadView() {
        if manuallyInitialized {
            let aView = AnimatingMenuView()
            aView.tableView.dataSource = self
            aView.tableView.delegate = self
            self.view = aView
        } else {
            super.loadView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if manuallyInitialized {
            // For this example, the menu table view is the full frame of the screen
            let screenFrame = UIScreen.main.bounds
            let tableFrame = CGRect(
                x: 0.0,
                y: topLayoutGuide.length,
                width: screenFrame.width,
                height: screenFrame.height
            )
            animatingView().refineTableViewLayout(with: tableFrame)
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}
