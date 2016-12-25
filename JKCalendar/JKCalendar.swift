//
//  JKCalendar.swift
//  JKCalendar
//
//  Created by Jarosław Krajewski on 23/12/2016.
//  Copyright © 2016 jerronimo. All rights reserved.
//

import UIKit

class JKCalendar: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var weekDayLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    var monthDifference = 0
    
    let date = ActivityDate.today()
    var selectedDate:ActivityDate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        collectionView.delegate = self
        collectionView.allowsSelection = true
    }
    
    func loadXib(){
        let view = UINib(nibName: "JKCalendar", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        self.collectionView.register(UINib(nibName: "JKCalendarHeader" , bundle:  nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "JKCalenderHeader")
        self.collectionView.register(UINib(nibName:"JKCalendarCell",bundle:nil), forCellWithReuseIdentifier: "JKCalendarCell")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func dateFor(section: Int) ->ActivityDate{
        let sectionDifference = monthDifference + section
        var sectionDate = ActivityDate(month: date.month, year: date.year)
        if sectionDifference < 0 {
            sectionDate = sectionDate.previous(months:sectionDifference * -1)
        }
        else{
            sectionDate = sectionDate.next(months: sectionDifference)
        }
        return sectionDate
    }
    
    func dateFor(indexPath: IndexPath) ->ActivityDate?{
        
        let sectionDate = dateFor(section: indexPath.section)
        let month = sectionDate.monthInformation()
        let weekComponents = Calendar.current.dateComponents([.month,.day,.weekday,.weekOfMonth], from: month.firstDay)
        
        var skipDays = weekComponents.weekday!
        if weekComponents.weekday == 1 {
            skipDays += 7
        }
        skipDays -= 2
        
        if indexPath.row < skipDays{
            return nil
        }
        
        let dayNumber = indexPath.row - skipDays + 1
        let daysInMonth = month.days
        if dayNumber - 1 >= daysInMonth {
            return nil
        }
        
        sectionDate.day = dayNumber
        return sectionDate
    }
}

// #MARK: - dataSource
extension JKCalendar{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JKCalendarCell", for: indexPath) as! JKCalendarCell
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! JKCalendarCell
        cell.isHidden = false
        
        let sectionDate = dateFor(indexPath: indexPath)
        
        if sectionDate == nil{
            cell.isHidden = true
            return
        }else{
            cell.isHidden = false
            
            cell.test.text = "\(sectionDate!.day!)"
        }
        
        if let selectedDate = selectedDate{
            if sectionDate!.year == selectedDate.year && sectionDate!.month ==
                selectedDate.month && sectionDate!.day == selectedDate.day{
                cell.selectionView.layer.cornerRadius = cell.selectionView.bounds.width / 2.0
                
                cell.selectionView.isHidden = false
            }
            else{
                cell.selectionView.isHidden = true
            }
            
        }else{
            cell.selectionView.isHidden = true
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
}

// MARK: - delegate
extension JKCalendar{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dateFor(indexPath: indexPath)
        dayLabel.text = selectedDate?.string(format: "d")
        monthLabel.text = selectedDate?.string(format: "MMM")
        yearLabel.text = selectedDate?.string(format: "yyyy")
        weekDayLabel.text = selectedDate?.string(format: "EEEE")
        collectionView.reloadData()
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
        let width = Int(collectionView.frame.width) / 7
        return CGSize(width: width, height: width)
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
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
            monthDifference += 1
            collectionView.reloadData()
        }
        else if distanceFromCenter <  -1 * contentWidth / 4.0{
            collectionView.contentOffset = CGPoint(x: currentOffset.x  , y: centerOffsetX)
            monthDifference -= 1
            collectionView.reloadData()
        }
    }
}
