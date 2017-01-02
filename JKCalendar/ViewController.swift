//
//  ViewController.swift
//  JKCalendar
//
//  Created by Jarosław Krajewski on 22/12/2016.
//  Copyright © 2016 jerronimo. All rights reserved.
//

import UIKit
import JKInfniniteCalendar

class ViewController: UIViewController {

    @IBOutlet var calendar: JKCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.selectedDate = ActivityDate.today().next(days: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

