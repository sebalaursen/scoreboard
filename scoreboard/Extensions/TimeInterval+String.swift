//
//  TimeInterval+String.swift
//  scoreboard
//
//  Created by Святослав Катола on 6/17/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func stringFormatted() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60

        return String(format:"%2d:%0.2d", minutes, seconds)
    }
}
