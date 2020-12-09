//
//  LPJPomodoroListCellView.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public class LPJPomodoroListCellView: UIView, CustomNibViewProtocol {
    
    var countDownChangeHandlers: [TimeIntervalBlock] = []
    var titleButtonClickHandlers: [((Bool) -> ())] = []
    
    var fold: Bool = true {
        didSet {
            changeFoldStatus(fold: fold)
        }
    }
    
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var titleBgView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupEvents()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupSubviews()
//        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSubviews() {
        datePicker.isHidden = fold
        contentBgView.layer.cornerRadius = 8
        contentBgView.clipsToBounds = true
    }
    
    func setupEvents() {
        datePicker.addTarget(self, action: #selector(LPJPomodoroListCellView.datePickerChangeAction(sender:)), for: .valueChanged)
        titleButton.addTarget(self, action: #selector(LPJPomodoroListCellView.titleButtonClickAction(sender:)), for: .touchUpInside)
    }
}

public extension LPJPomodoroListCellView {
    
    func addAction(datePickerChangeEvent: @escaping TimeIntervalBlock) {
        countDownChangeHandlers.append(datePickerChangeEvent)
    }
    
    func addAction(titleButtonClickEvent: @escaping ((Bool) -> ())) {
        titleButtonClickHandlers.append(titleButtonClickEvent)
    }
    
    func updateButtonTitle(text: String) {
        titleButton.setTitle(text, for: .normal)
    }
    
    func updateDatePickerCountDownTime(with countDown: TimeInterval) {
        datePicker.countDownDuration = countDown
    }
}

extension LPJPomodoroListCellView {
    
    func changeFoldStatus(fold: Bool) {
        datePicker.isHidden = fold
    }
    
    @objc
    func datePickerChangeAction(sender: UIDatePicker?) {
        if let senderTmp = sender, senderTmp == self.datePicker {
            countDownChangeHandlers.forEach { $0(senderTmp.countDownDuration) }
        }
    }
    
    @objc
    func titleButtonClickAction(sender: UIButton?) {
        if let senderTmp = sender, senderTmp == self.titleButton {
            titleButtonClickHandlers.forEach { $0(fold) }
        }
    }
}
