//
//  Month.swift
//  Presell
//
//  Created by Jarosław Krajewski on 06/12/2016.
//  Copyright © 2016 Ekspert Systemy Informatyczne. All rights reserved.
//

import Foundation



class Month{
    let firstDay:Date
    let lastDay: Date
    
    var days:Int{
        get{
             return Calendar.current.dateComponents([.day], from: firstDay, to: lastDay).day!
        }
    }
    init(year: Int, month:Int){
        
        var thisMonthComponent = DateComponents()
        thisMonthComponent.month = month
        thisMonthComponent.year = year
        
        firstDay = Calendar.current.date(from:  thisMonthComponent)!
        
        var lastDayComponents = DateComponents()
        lastDayComponents.month = 1
        
        
        lastDay = Calendar.current.date(byAdding: lastDayComponents, to: firstDay)!
        
    }
    
}



