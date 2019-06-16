//
//  Settings.swift
//  scoreboard
//
//  Created by Sebastian on /16/6/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

class Settings {
    static var maxTime: Int{
        let res = UserDefaults.standard.integer(forKey: "maxTime")
        return res ==  0 ? 3 : res
    }
    static var maxPoint: Int{
        let res = UserDefaults.standard.integer(forKey: "maxPoints")
        return res == 0 ? 5 : res
    }
    
    static func setMaxTime(_ time: Int) {
        UserDefaults.standard.set(time, forKey: "maxTime")
    }
    
    static func setMaxPoint(_ point: Int) {
        UserDefaults.standard.set(point, forKey: "maxPoints")
    }
}
