//
//  ContactsViewController.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class ContactsViewController : UIViewController {
    private var viewModel : ContactsViewModel
    private let segmentedController : UISegmentedControl
    private let tableView : UITableView
    private let collectionView : UICollectionView
    private let activityIndicator : UIActivityIndicatorView
    private var hidenView : UIView?
    private enum SourceView: Int {
        case list = 0, grid
    }
    
    private var bottomUnVisibleCellFrame : CGRect {
        CGRect(x: Space.double, y: UIScreen.main.bounds.height - Space.double + CGFloat.random(in: 0...10) * 50.0, width: 40, height: 40)
    }
    
    private var topUnvisibleCell : CGRect {
        CGRect(x: Space.double, y: view.bounds.minY -  CGFloat.random(in: 0...10) * 50.0, width: 40, height: 40)
    }
    
    init(viewModel : ContactsViewModel) {
        self.viewModel = viewModel
        self.tableView = UITableView()
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.segmentedController = UISegmentedControl(items: [Strings.list, Strings.grid])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        setupToolBar()
        setupActivityIndicator()
        viewModel.simulateChanges()
        activityIndicator.startAnimating()
        
        viewModel.usersListDidChange = { [weak self] in
            guard let self = self else { return }
            self.toolbarItems?.forEach { $0.isEnabled = true }
            self.updateCollections()
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidenView?.isHidden = false
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.registerReusableCell(ContactCollectionViewCell.self)
        setupMainConstrains(collectionView)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerReusableCell(ContactTableViewCell.self)
        setupMainConstrains(tableView)
    }
    
    private func setupMainConstrains(_ childView : UIView) {
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            childView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        guard let barView = navigationController?.navigationBar else { fatalError() }
        barView.addSubview(segmentedController)
        segmentedController.setTitleTextAttributes(String.attributedString(font : Font.subtitle.uiFont, txtColor: UIColor.black), for: .normal)
        (0..<segmentedController.subviews.count).forEach {
            segmentedController.setWidth(UIScreen.main.bounds.width / 3, forSegmentAt: $0)
        }
        segmentedController.addTarget(self, action: #selector(segmentedControlDidPressed(sender:)), for: .valueChanged)
        segmentedController.selectedSegmentIndex = 0
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedController.centerYAnchor.constraint(equalTo: barView.centerYAnchor),
            segmentedController.centerXAnchor.constraint(equalTo: barView.centerXAnchor)
        ])
    }
    
    private func setupToolBar() {
        let toolBarItem = UIBarButtonItem(title: Strings.changes,
                                          style: .plain,
                                          target: self, action: #selector(changesButtonDidPress(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([flexibleSpace, toolBarItem, flexibleSpace], animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateCollections() {
        collectionView.reloadSections(IndexSet(arrayLiteral: 0))
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
}

// MARK: - Animations
extension ContactsViewController {
    private func segmentedControlHandler(_ source : SourceView?) {
        guard let newSource = source else { return }
        let allIndexPaths = (0..<viewModel.usersCount).map { IndexPath(row: $0, section: 0) }
        let collectionViewAllCells = allIndexPaths.compactMap { collectionView.cellForItem(at: $0) as? ContactCollectionViewCell }
        let tableViewAllCells = allIndexPaths.compactMap { tableView.cellForRow(at: $0) as? ContactTableViewCell }
        hideViews(willHide: true, tableViewAllCells)
        hideViews(willHide: true, collectionViewAllCells)
        let sourceFrames = newSource == .grid ? tableViewFrames() : collectionViewFrames()
        let destinationFrames = newSource == .grid ? collectionViewFrames() : tableViewFrames()
        var subviews = [UIView]()
        
        allIndexPaths.forEach { indexPath in
            let imageView = AvatarImage(borderWidth: ImageBorders.small)
            viewModel.imageForIndex(indexPath.row) { (image) in
                imageView.configure(image: image, status: self.viewModel.statusForIndex(indexPath.row))
            }
            if sourceFrames.count > indexPath.row {
                imageView.frame = sourceFrames[indexPath.row]
            }
            view.addSubview(imageView)
            subviews.append(imageView)
        }
            
        UIView.animate(withDuration: 0.6, animations: {
            self.segmentedController.isEnabled = false
            subviews.forEach { subview in
                if let index = subviews.firstIndex(of: subview), index < destinationFrames.count {
                    subview.frame = destinationFrames[index]
                }
            }
        }, completion: { (_) in
            subviews.forEach({ $0.removeFromSuperview() })
            self.hideViews(willHide: false, tableViewAllCells)
            self.hideViews(willHide: false, collectionViewAllCells)
        })
        self.segmentedController.isEnabled = true
        self.tableView.isHidden = newSource == .grid
    }
    
    private func tableViewFrames() -> [CGRect] {
        let allIndexPaths = (0..<viewModel.usersCount).map { IndexPath(row: $0, section: 0) }
        let tableViewVisibleCells = tableView.visibleCells as! [ContactTableViewCell]
        let cellIndexPaths = tableViewVisibleCells.compactMap { tableView.indexPath(for: $0) }
        return convertIndexesToFrames(allIndexPaths, cellIndexPaths, .list)
    }
    
    private func collectionViewFrames () -> [CGRect] {
        let allIndexPaths = (0..<viewModel.usersCount).map { IndexPath(row: $0, section: 0) }
        let collectionViewVisibleCells = collectionView.visibleCells as! [ContactCollectionViewCell]
        let cellIndexPaths = collectionViewVisibleCells.compactMap { collectionView.indexPath(for: $0) }
        return convertIndexesToFrames(allIndexPaths, cellIndexPaths, .grid)
    }
    
    private func convertIndexesToFrames(_ allIndexPaths : [IndexPath], _ visiblePaths: [IndexPath], _ type : SourceView) -> [CGRect] {
        allIndexPaths.map { indexPath -> CGRect in
            if type == .list, visiblePaths.contains(indexPath),
                let tableCell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell {
                    return tableCell.convert(tableCell.avatar.frame, to: view)
            } else if type == .grid, visiblePaths.contains(indexPath) {
                    let collectionCell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell ?? ContactCollectionViewCell()
                    return collectionCell.convert(collectionCell.avatar.frame, to: view)
            } else if let currentIndexPath = visiblePaths.first, indexPath.row  < currentIndexPath.row {
                return topUnvisibleCell
            } else {
                return bottomUnVisibleCellFrame
            }
        }
    }
    
    private func hideViews(willHide : Bool, _ views: [UIView]) {
        views.forEach { $0.isHidden = willHide}
    }
}

// MARK: - UITableViewDataSource
extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(ContactTableViewCell.self) else { fatalError() }
        viewModel.imageForIndex(indexPath.row) { [weak self] (image) in
            guard let self = self else { return }
            itemCell.configure(avatar: image,
                               status: self.viewModel.statusForIndex(indexPath.row),
                               name: self.viewModel.nameForIndex(indexPath.row))
        }
        return itemCell
    }
}

// MARK: - UITableViewDelegate
extension ContactsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell else { return }
        hidenView = cell.avatar
        hidenView?.isHidden = true
        let avatar = cell.avatar.frame
        viewModel.showAvatarDelails(for: indexPath, originFrame: cell.convert(avatar, to: view))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight.tableView
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

// MARK: - UICollectionViewDataSource
extension ContactsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.usersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = collectionView.dequeueReusableCell(ContactCollectionViewCell.self, for: indexPath) else { fatalError() }
        viewModel.imageForIndex(indexPath.row) { [weak self] (image) in
            itemCell.configure(image: image, statusImage: self?.viewModel.statusForIndex(indexPath.row))
        }
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeUser(indexPath.row)
            updateCollections()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ContactsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CellHeight.collectionView, height: CellHeight.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Space.single
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Space.single
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else { return }
        hidenView = cell.avatar
        hidenView?.isHidden = true
        let avatar = cell.avatar.frame
        viewModel.showAvatarDelails(for: indexPath, originFrame: cell.convert(avatar, to: view))
    }
}

// MARK: - Actions
@objc private extension ContactsViewController {
    func segmentedControlDidPressed(sender : UISegmentedControl) {
        let source = SourceView.init(rawValue: sender.selectedSegmentIndex)
        segmentedControlHandler(source)
    }
    
    func changesButtonDidPress(sender : UIBarButtonItem) {
        sender.isEnabled = false
        viewModel.simulateChanges()
        activityIndicator.startAnimating()
    }
}
