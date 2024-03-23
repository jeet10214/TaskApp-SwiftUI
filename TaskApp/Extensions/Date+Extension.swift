//
//  Date+Extension.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

extension Date {
    
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
    
}
