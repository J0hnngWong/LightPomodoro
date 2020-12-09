//
//  LPJPomodoroListViewController.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class LPJPomodoroListViewController: UIViewController {
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(LPJPomodoroListViewController.addAction))
        return button
    }()
    
    lazy var fireButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(LPJPomodoroListViewController.fireAction))
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LPJPomodoroListCell.self, forCellReuseIdentifier: LPJPomodoroListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let viewModel: LPJPomodoroListViewModel
    
    init(with viewModel: LPJPomodoroListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LPJPomodoroListViewController {
    
    func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.lpj.left.to(item: self.view).left.offset(constant: 0, safeArea: true)
        tableView.lpj.right.to(item: self.view).right.offset(constant: 0, safeArea: true)
        tableView.lpj.bottom.to(item: self.view).bottom.offset(constant: 0, safeArea: true)
        tableView.lpj.top.to(item: self.view).top.offset(constant: 0, safeArea: true)
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = fireButton
    }
    
    func setupEvents() {
        
        self.viewModel.dataChangedHandler = { [weak self] (action, index, pomodoroDatas) in
            guard let sself = self else { return }
            sself.tableViewUpdate(with: action, at: [IndexPath(row: index, section: 0)], completion: nil)
        }
    }
    
    func tableViewUpdate(with action: DataChangeAction, at indexPaths: [IndexPath], completion: ((Bool) -> ())? = nil) {
        tableView.performBatchUpdates({
            if action == .delete {
                self.tableView.deleteRows(at: indexPaths, with: .automatic)
            } else if action == .insert {
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            } else if action == .reload {
                UIView.animate(withDuration: 0.3) {
                    self.tableView.reloadRows(at: indexPaths, with: .none)
                }
            }
        }, completion: { [weak self] (finish) in
            guard let sself = self else { return }
            sself.tableView.reloadData()
            completion?(finish)
        })
    }
    
    func updateCell(cell: LPJPomodoroListCell, for indexPath: IndexPath) {
        if let modelTmp = SAFE_OBJECT_FROM(arr: viewModel.dataManager.pomodoroData, index: indexPath.row) {
            cell.updateCellUseModel(model: modelTmp)
        }
        cell.cellView.fold = viewModel.foldStatus[indexPath.row]
        cell.foldStatuChangeHandler = { [weak self] (foldStatus) in
            guard let sself = self else { return }
            sself.viewModel.foldStatus[indexPath.row] = foldStatus
            sself.tableViewUpdate(with: .reload, at: [indexPath])
        }
        cell.countDownTimeIntervalChangeHandler = { [weak self] (countDown) in
            guard let sself = self else { return }
            sself.viewModel.updateTimeCell(with: indexPath, countDown: countDown)
        }
    }
}

extension LPJPomodoroListViewController {
    
    @objc
    func addAction() {
        // add
        viewModel.addNewTimeCell()
    }
    
    @objc
    func fireAction() {
        
    }
}

extension LPJPomodoroListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.dataManager.pomodoroData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LPJPomodoroListCell.reuseIdentifier, for: indexPath) as? LPJPomodoroListCell ?? LPJPomodoroListCell()
        updateCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.foldStatus[indexPath.row] {
            return LPJPomodoroListCell.cellFoldStatusHeight
        } else {
            return LPJPomodoroListCell.cellUnfoldStatusHeight
        }
    }
    
    // trailing swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRowAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, sourceView, completeHandler) in
            guard let sself = self else { return }
            if let identifier = SAFE_OBJECT_FROM(arr: sself.viewModel.dataManager.pomodoroData, index: indexPath.row)?.id {
                // delete
                sself.viewModel.deleteTimeCellWith(identifier: identifier)
            }
        }
        deleteRowAction.image = UIImage(systemName: "minus")
        deleteRowAction.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [deleteRowAction])
        return config
    }
}
