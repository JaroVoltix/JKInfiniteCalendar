//
//  JKCalendarCell
//  JKCalendar
//
//  Created by Jarosław Krajewski on 23/12/2016.
//  Copyright © 2016 jerronimo. All rights reserved.
//

import UIKit

class JKCalendarCell: UICollectionViewCell {
    @IBOutlet var test: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("JKCalendarCell", owner: self, options: nil)?[0] as! UIView
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
