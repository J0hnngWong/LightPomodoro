//
//  LPJPomodoroListViewModel.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class LPJPomodoroListViewModel {
    
    let dataManager: DataManager
    
    var foldStatus: [Bool] = []
    
    init(with dataManager: DataManager) {
        self.dataManager = dataManager
        setupData(using: dataManager)
    }
    
    func setupData(using manager: DataManager) {
        for _ in manager.pomodoroData {
            foldStatus.append(true)
        }
        
        manager.addObserve { [weak self] (pomodoroDatas) in
            guard let sself = self else { return }
            while sself.foldStatus.count < pomodoroDatas.count {
                sself.foldStatus.append(true)
            }
            while sself.foldStatus.count < pomodoroDatas.count {
                sself.foldStatus.removeLast()
            }
        }
    }
}
