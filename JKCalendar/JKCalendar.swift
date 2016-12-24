//
//  JKCalendar.swift
//  JKCalendar
//
//  Created by Jarosław Krajewski on 23/12/2016.
//  Copyright © 2016 jerronimo. All rights reserved.
//

import UIKit



class JKCalendar: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var test = 0
    
    let date = ActivityDate.today()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.frame = self.bounds
        self.collectionView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    func loadXib(){
        let view = UINib(nibName: "JKCalendar", bundle: nil).instantiate(withOwner: self, options: nil)[0]
        addSubview(view as! UIView)
        
        self.collectionView.register(UINib(nibName: "JKCalendarHeader" , bundle:  nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "JKCalenderHeader")
        
        self.collectionView.register(JKCalendarCell.self, forCellWithReuseIdentifier: "JKCalendarCell")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
 

    override func prepareForInterfaceBuilder() {
        backgroundColor = UIColor.red
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.red
    }
    
    
    func dateFor(section: Int) ->ActivityDate{
        let monthID = test + section
        var sectionDate = date
        if monthID < 0 {
            for _ in 0 ..< (-1 * monthID){
                sectionDate = sectionDate.previousMonth()
            }
        }
        else{
            for _ in 0 ..<  monthID{
                sectionDate = sectionDate.nextMonth()
            }
        }
        return sectionDate

        
    }
}

// #MARK: - dataSource
extension JKCalendar{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JKCalendarCell", for: indexPath) as! JKCalendarCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! JKCalendarCell
        cell.isHidden = false

        let sectionDate = dateFor(section: indexPath.section)
       
        let month = sectionDate.monthInformation()
        let weekComponents = Calendar.current.dateComponents([.month,.day,.weekday,.weekOfMonth], from: month.firstDay)
        
        var skipDays = weekComponents.weekday!
        if weekComponents.weekday == 1 {
            skipDays += 7
        }
        skipDays -= 2
        
        if indexPath.row < skipDays{
            cell.isHidden = true
        }
        
        let dayNumber = indexPath.row - skipDays + 1
        let daysInMonth = month.days
        if dayNumber - 1 >= daysInMonth {
            cell.isHidden = true
        }
        
        cell.test.text = "\(dayNumber)"
        cell.backgroundColor = UIColor.white
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.red
        }
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
}

// MARK: - layout
extension JKCalendar{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.bounds.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
            
        case UICollectionElementKindSectionHeader:
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JKCalenderHeader", for: indexPath) as! JKCalendarHeader
            let sectionDate = dateFor(section: indexPath.section)
           
            header.monthLabel.text = sectionDate.monthAndYear
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.bounds.width / CGFloat(7)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK: - scroll
extension JKCalendar{
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = collectionView.contentOffset
        let contentWidth = collectionView.contentSize.height
        let centerOffsetX = (contentWidth - self.collectionView.bounds.size.height) / 2.0
        let distanceFromCenter = currentOffset.y - centerOffsetX
        if distanceFromCenter > contentWidth / 4.0 {
            collectionView.contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetX)
            test += 1
            collectionView.reloadData()
        }
        else if distanceFromCenter <  -1 * contentWidth / 4.0{
            collectionView.contentOffset = CGPoint(x: currentOffset.x  , y: centerOffsetX)
            test -= 1
            collectionView.reloadData()
        }
    }
}
