//
//  PomodoroDataCell.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/11/27.
//  Copyright © 2020 Johnny. All rights reserved.
//

import SwiftUI

struct PomodoroDataCell: View {
    
    var model: PomodoroModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Hours")
                Text("\(model.countDownTimeInterval)")
            }
        }
    }
}

struct PomodoroDataCell_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroDataCell(model: fakePomodoroData)
    }
}
