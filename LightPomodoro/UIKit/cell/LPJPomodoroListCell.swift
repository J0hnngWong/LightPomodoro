//
//  LPJPomodoroListCell.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public class LPJPomodoroListCell: UITableViewCell, CustomNibViewProtocol {
    
    static let cellFoldStatusHeight: CGFloat = 64 + 16 + 16
    
    static let cellUnfoldStatusHeight: CGFloat = 240 + 16 + 16
    
    public var foldStatuChangeHandler: ((Bool) -> ())?
    public var countDownTimeIntervalChangeHandler: TimeIntervalBlock?
    
    public static let reuseIdentifier = NSStringFromClass(LPJPomodoroListCell.classForCoder())
    
    public lazy var cellView: LPJPomodoroListCellView = {
        let cellView = LPJPomodoroListCellView.getView(defaultView: LPJPomodoroListCellView(frame: .zero))
//        cellView.layer.cornerRadius = 8
        cellView.layer.shadowColor = nil
        cellView.layer.shadowRadius = 8
        cellView.layer.shadowOpacity = 0.16
        cellView.layer.shadowOffset = .zero
        cellView.clipsToBounds = false
        cellView.backgroundColor = .clear
//        cellView.clipsToBounds = true
        return cellView
    }()
    
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
        
        cellView.addAction(titleButtonClickEvent: { [weak self] (foldStatus) in
            guard let sself = self else { return }
            sself.cellView.fold = !foldStatus
            sself.foldStatuChangeHandler?(sself.cellView.fold)
        })
        
        cellView.addAction(datePickerChangeEvent: { [weak self] (countDown) in
            guard let sself = self else { return }
            sself.cellView.updateButtonTitle(text: sself.getFormatCountDownString(from: countDown))
            sself.countDownTimeIntervalChangeHandler?(countDown)
        })
    }
    
    func getFormatCountDownString(from countDown: TimeInterval) -> String {
        let minutes = Int(countDown)%60
        let hours = Int(countDown)/60
        return String(format: "CountDown: %02ld:%02ld", hours, minutes)
    }
    
    func updateCellUseModel(model: PomodoroModel) {
        cellView.updateButtonTitle(text: getFormatCountDownString(from: model.countDownTimeInterval))
        cellView.updateDatePickerCountDownTime(with: model.countDownTimeInterval)
    }
}
