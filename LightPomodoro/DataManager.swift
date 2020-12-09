//
//  DataManager.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/11/27.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import Combine

public enum DataChangeAction {
    case reload
    case insert
    case delete
}

final class DataManager: ObservableObject {
    
    public var pomodoroDataChangeHandlers: [((DataChangeAction, Int, [PomodoroModel]) -> ())] = []
    
    public static let shared = DataManager()
    
    @Published public var pomodoroData: [PomodoroModel] = []
    
    private init() {
        
    }
    
    public func addObserve(pomodoroDataChangeEvent: @escaping ((DataChangeAction, Int, [PomodoroModel]) -> ())) {
        pomodoroDataChangeHandlers.append(pomodoroDataChangeEvent)
    }
    
    
    /// delete
    @discardableResult
    func deletePomodoroData(identifier: UUID) -> Bool {
        while let indexTmp = pomodoroData.firstIndex(where: { $0.id == identifier }) {
            pomodoroData.remove(at: indexTmp)
            dataChangeNotification(with: .delete, at: indexTmp)
        }
        return true
    }
    
    /// add
    @discardableResult
    func addPomodoroData(model: PomodoroModel, at index: Int? = nil) -> Bool {
        if let indexTmp = index, indexTmp < pomodoroData.count {
            pomodoroData.insert(model, at: indexTmp)
            dataChangeNotification(with: .insert, at: indexTmp)
        } else {
            pomodoroData.append(model)
            dataChangeNotification(with: .insert, at: pomodoroData.count-1)
        }
        return true
    }
    
    @discardableResult
    func updatePomodoroData(identifier: UUID, countDownInterval: TimeInterval) -> Bool {
        var indexSet: [Int] = []
        if
            let index = pomodoroData.firstIndex(where: { $0.id == identifier }),
            !indexSet.contains(index)
        {
            pomodoroData[index].countDownTimeInterval = countDownInterval
            indexSet.append(index)
        }
        return true
    }
    
    func dataChangeNotification(with action: DataChangeAction, at index: Int) {
        pomodoroDataChangeHandlers.forEach { $0(action, index, pomodoroData) }
    }
}


public struct PomodoroModel: Hashable, Codable, Identifiable {
    
    public var id: UUID
    
    var countDownTimeInterval: TimeInterval
}


let fakePomodoroData = PomodoroModel(id: UUID(), countDownTimeInterval: 0)

var fakePomodoroListData: [PomodoroModel] {
    
    var arr: [PomodoroModel] = []
    for item in 0...10 {
        arr.append(PomodoroModel(id: UUID(), countDownTimeInterval: TimeInterval(item)))
    }
    return arr
}
