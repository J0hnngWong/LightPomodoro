//
//  LPJPomodoroListCell.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public class LPJPomodoroListCell: UITableViewCell, CustomNibViewProtocol {
    
    public var foldStatuChangeHandler: VoidBlock?
    
    public static let reuseIdentifier = NSStringFromClass(LPJPomodoroListCell.classForCoder())
    
    public let cellView = LPJPomodoroListCellView.getView(defaultView: LPJPomodoroListCellView(frame: .zero))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupEvents()
    }
    
    func setupSubviews() {
        contentView.addSubview(cellView)
        cellView.lpj.left.to(item: contentView).left.offset(constant: 16)
        cellView.lpj.top.to(item: contentView).top.offset(constant: 16)
        cellView.lpj.right.to(item: contentView).right.offset(constant: -16)
        cellView.lpj.bottom.to(item: contentView).bottom.offset(constant: -16)
    }
    
    func setupEvents() {
        cellView.addAction { [weak self] in
            guard let sself = self else { return }
            sself.cellView.fold = !sself.cellView.fold
            sself.foldStatuChangeHandler?()
        }
    }
}
