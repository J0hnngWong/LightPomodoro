//
//  ContentView.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/11/27.
//  Copyright © 2020 Johnny. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        List {
            ForEach(dataManager.pomodoroData) { (data) in
                PomodoroDataCell(model: data)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(DataManager.shared)
    }
}
