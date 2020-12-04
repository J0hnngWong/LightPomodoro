//
//  DataManager.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/11/27.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import Combine

final class DataManager: ObservableObject {
    
    public var pomodoroDataChangeHandlers: [(([PomodoroModel]) -> ())] = []
    
    public static let shared = DataManager()
    
    @Published var pomodoroData: [PomodoroModel] = fakePomodoroListData {
        didSet {
            pomodoroDataChangeHandlers.forEach { $0(pomodoroData) }
        }
    }
    
    private init() {
        
    }
    
    public func addObserve(pomodoroDataChangeEvent: @escaping (([PomodoroModel]) -> ())) {
        pomodoroDataChangeHandlers.append(pomodoroDataChangeEvent)
    }
}


public struct PomodoroModel: Hashable, Codable, Identifiable {
    
    public var id: UUID
    
    var hour: Int
    var minute: Int
    var second: Int
}


let fakePomodoroData = PomodoroModel(id: UUID(), hour: 10, minute: 20, second: 30)

var fakePomodoroListData: [PomodoroModel] {
    
    var arr: [PomodoroModel] = []
    for item in 0...10 {
        arr.append(PomodoroModel(id: UUID(), hour: item, minute: item, second: item))
    }
    return arr
}
