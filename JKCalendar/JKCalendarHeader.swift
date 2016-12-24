//
//  JKCalendarHeader.swift
//  JKCalendar
//
//  Created by Jarosław Krajewski on 23/12/2016.
//  Copyright © 2016 jerronimo. All rights reserved.
//

import UIKit

class JKCalendarHeader: UICollectionReusableView {

    @IBOutlet var monthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("JKCalendarHeader", owner: self, options: nil)?[0]
        addSubview(view as! UIView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
