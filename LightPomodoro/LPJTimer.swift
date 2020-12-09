//
//  LPJTimer.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/9.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class LPJTimer: NSObject, UNUserNotificationCenterDelegate {
    
    public static let shared = LPJTimer()
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (confirmed, error) in
            if !confirmed || error != nil {
                self.showOpenNotificationAlert()
            }
        }
    }
    
    func startCountDown(from interval: TimeInterval, completion: (() -> ())?) {
        
        
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.body = "aaa"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "aaa", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let errorTmp = error {
                print(errorTmp)
            }
        }
        
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [""])
    }
    
    func showOpenNotificationAlert() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false]) { (finish) in
                }
            }
        }
    }
    
    
}
