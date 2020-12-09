//
//  LPJPomodoroListViewModel.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class LPJPomodoroListViewModel {
    
    var dataChangedHandler: ((DataChangeAction, Int, [PomodoroModel]) -> ())?
    
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
        
        manager.addObserve { [weak self] (action, index, pomodoroDatas) in
            guard let sself = self else { return }
            while sself.foldStatus.count < pomodoroDatas.count {
                sself.foldStatus.append(true)
            }
            while sself.foldStatus.count < pomodoroDatas.count {
                sself.foldStatus.removeLast()
            }
        }
        
        manager.addObserve { [weak self] (action, index, pomodoroDatas) in
            guard let sself = self else { return }
            sself.dataChangedHandler?(action, index, pomodoroDatas)
        }
    }
    
    func addNewTimeCell() {
        dataManager.addPomodoroData(model: PomodoroModel(id: UUID(), countDownTimeInterval: 0))
    }
    
    func deleteTimeCellWith(identifier: UUID) {
        dataManager.deletePomodoroData(identifier: identifier)
    }
    
    func updateTimeCell(with indexPath: IndexPath, countDown: TimeInterval) {
        if let identifier = SAFE_OBJECT_FROM(arr: dataManager.pomodoroData, index: indexPath.row)?.id {
            dataManager.updatePomodoroData(identifier: identifier, countDownInterval: countDown)
        }
    }
    
    func searchForTimeCell(identifier: UUID) -> PomodoroModel {
        return PomodoroModel(id: identifier, countDownTimeInterval: 0)
    }
}
