//
//  LPJPomodoroListViewController.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class LPJPomodoroListViewController: UIViewController {
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LPJPomodoroListCell.self, forCellReuseIdentifier: LPJPomodoroListCell.reuseIdentifier)
        return tableView
    }()
    
    let viewModel: LPJPomodoroListViewModel
    
    init(with viewModel: LPJPomodoroListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
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
    }
    
    func tableViewUpdate(with indexPath: IndexPath) {
//        tableView.performBatchUpdates({
//            self.tableView.reloadSections(IndexSet(integer: 0), with: .bottom)
//        }) { (finish) in
//            self.tableView.reloadData()
//        }
        UIView.animate(withDuration: 0.3) {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
//        tableView.reloadData()
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
        cell.cellView.fold = viewModel.foldStatus[indexPath.row]
        cell.foldStatuChangeHandler = { [weak self] (foldStatus) in
            guard let sself = self else { return }
            sself.viewModel.foldStatus[indexPath.row] = foldStatus
            sself.tableViewUpdate(with: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.foldStatus[indexPath.row] {
            return LPJPomodoroListCell.cellFoldStatusHeight
        } else {
            return LPJPomodoroListCell.cellUnfoldStatusHeight
        }
    }
}
