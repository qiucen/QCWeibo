//
//  HomeTableViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SVProgressHUD

// MARK: - cell ID
let kStatusOriginalCellId = "kStatusOriginalCellId"
let kStatusRetweetedCellId = "kStatusRetweetedCellId"
let kStatusTableViewCellId = "kStatusTableViewCellId"


private let kNavigationBarHeight: CGFloat = 60

/// `home view controller`
class HomeTableViewController: UIViewController {
    
    // MARK: - lazy
    private lazy var tableView = UITableView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private lazy var statusListModel = StatusListViewModel()
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .lightGray
        return indicator
    }()
    /// `shows to inform user new status' count`
    private lazy var pullDownTipLabel: UILabel = {
        let label = UILabel(title: "", textColor: .white, fontSize: 18)
        label.backgroundColor = .orange
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        return label
    }()
    
    /// `transitioning animator`
    private lazy var photoBrowserAnimator = PhotoBrowserAnimator()

 
    override func loadView() {
        super.loadView()
        setNavItems()
        prepareTableView()
        
    }
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        printQCDebug(message: tableView)
        
                
        if !UserAccountViewModel.shared.userLogin {
            let visitorView = VisitorView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - kNavigationBarHeight - 44))
            visitorView.loginButton.isUserInteractionEnabled = true
            view.addSubview(visitorView)
            return
        }
        
        loadData()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(kStatusSelectedPhotoNotification),
            object: nil,
            queue: nil) { [weak self] (notification) in
                
                guard let indexPath = notification.userInfo?[kStatusSelectedPhotoAtIndexPathKey]
                    as? IndexPath else { return }
                guard let urls = notification.userInfo?[kStatusSelcetedPhotoURLsKey]
                    as? [URL] else { return }
                guard let cell = notification.object as? PhotoBrowserPresentDelegate else { return }
                
                let vc = PhotoBrowserViewController(urls: urls, indexPath: indexPath)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self?.photoBrowserAnimator
                
                self?.photoBrowserAnimator.setDelegateParams(
                    presentDelegate: cell,
                    indexPath: indexPath,
                    dismissDelegate: vc
                )
                
                self?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}




// MARK: - Table view data source
extension HomeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// `count`
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListModel.statusList.count
    }
    
    /// `cell`
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = statusListModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellId, for: indexPath) as! StatusTableViewCell
        cell.viewModel = viewModel
        if indexPath.row == statusListModel.statusList.count - 1 && !pullUpView.isAnimating {
            pullUpView.startAnimating()
            loadData()
        }
        return cell
    }
    
    /// `row height`
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusListModel.statusList[indexPath.row].rowHeight
    }
    
    /// `did select row at index path`
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printQCDebug(message: "选中行 \(indexPath)")
    }

}


// MARK: - prepare table view and set navigation bar
extension HomeTableViewController {
    
    /// `set navigation bar items`
    private func setNavItems() {
        let nav = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavigationBarHeight))
        let items = UINavigationItem()
        // `only shows item camera, without actions`
        let itemCamera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        let itemCompose = UIBarButtonItem(image: UIImage(named: "compose_toolbar_more"), style: .plain, target: self, action: #selector(clickCompose))
        items.title = "微博"
        items.leftBarButtonItem = itemCamera
        items.rightBarButtonItem = itemCompose
        nav.setItems([items], animated: false)
        view.addSubview(nav)
    }
    
    
    /// `prepare table view`
    private func prepareTableView() {
        
        // `register`
        tableView.register(StatusOriginalCell.self, forCellReuseIdentifier: kStatusOriginalCellId)
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: kStatusRetweetedCellId)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.refreshControl = RefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.tableFooterView = pullUpView
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    
    /// `load data`
    @objc func loadData() {
        tableView.refreshControl?.beginRefreshing()
        statusListModel.loadStatus(isPullUp: pullUpView.isAnimating) { (isSuccess) in
            self.tableView.refreshControl?.endRefreshing()
            self.pullUpView.stopAnimating()
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "can not load data for now")
                return
            }
            self.showPullDownTip()
            self.tableView.reloadData()
        }
    }
    
    /// `shows pull down tip with animation`
    private func showPullDownTip() {
        guard let count = statusListModel.pulldownCount else { return }
        printQCDebug(message: "下拉刷新 \(count)")
        pullDownTipLabel.text = (count == 0) ? "没有新微博" : "刷新到 \(count) 条微博"
        let height: CGFloat = 44
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        pullDownTipLabel.frame = rect.offsetBy(dx: 0, dy: height)
        UIView.animate(withDuration: 0.5, animations: {
            self.pullDownTipLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 1.0) {
                self.pullDownTipLabel.alpha = 0
            }
        }
        
    }
    
    
    /// `click compose item`
    @objc func clickCompose() {
        printQCDebug(message: "Click compose!")
        var vc: UIViewController
        if UserAccountViewModel.shared.userLogin {
            vc = ComposeViewController()
        } else {
            vc = OAuthViewController()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
