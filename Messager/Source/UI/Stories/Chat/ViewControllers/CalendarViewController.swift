//
//  CalendarViewController.swift
//  Messager
//
//  Created by Silchenko on 28.11.2018.
//

import UIKit

protocol CalendarViewControllerDelegate: class {
    func didTappedCancelButton(viewController: CalendarViewController)
    func didChoseDate(_ date: Date, viewController: CalendarViewController)
}

class CalendarViewController: UIViewController {

    weak var delegate: CalendarViewControllerDelegate?
    
    @IBOutlet private weak var currentNumberLabel: UILabel!
    @IBOutlet private weak var currentMounthLabel: UILabel!
    @IBOutlet private weak var currentYearLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backgroundView: UIView!
    
    private var currentDay: Int {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.day], from: Date())
        return day.day!
    }
    
    private var currentMonth: Int {
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: Date())
        return month.month!
    }
    
    private var currentYear: Int {
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: Date())
        return year.year!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentMounthLabel.text = Date().toString(dateFormat: "MMMM")
        currentNumberLabel.text = String(currentDay)
        currentYearLabel.text = String(currentYear)
        collectionView.scrollToLastItem()
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row - 7 < 0 {
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundView?.layer.cornerRadius = cell.frame.size.width/2
            cell.backgroundView?.backgroundColor = .gray
            
            let dateComponents = DateComponents(year: currentYear,
                                               month: indexPath.section + 1,
                                                 day: indexPath.row - 6 - getIndexDay(name: getFirstDayInMouth(mouth: indexPath.section + 1)),
                                                hour: 12)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            
            delegate?.didChoseDate(date, viewController: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dateComponents = DateComponents(year: currentYear, month: section + 1)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays + 7 + getIndexDay(name: getFirstDayInMouth(mouth: section + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        for view in headerView.subviews {
            view.removeFromSuperview()
        }
        headerView.addSubview(createHeaderView(forCell: headerView, with: indexPath))
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: IndexPath(row: indexPath.row, section: indexPath.section))
        cell.backgroundView = getDaysView(forCell: cell, with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7, height: collectionView.frame.width/7)
    }
}

private extension CalendarViewController {
    
    func getFirstDayInMouth(mouth: Int) -> String {
        let calendar = Calendar.current
        let dateComponentsDay = DateComponents(year: currentYear, month: mouth, day: 1)
        let dateDay = calendar.date(from: dateComponentsDay)!
        return dateDay.toString(dateFormat: "EE")
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.backgroundViewTapped))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func backgroundViewTapped() {
        delegate?.didTappedCancelButton(viewController: self)
    }
    
    func createHeaderView(forCell cell: UICollectionReusableView, with indexPath: IndexPath) -> UIView {
        let dateComponents = DateComponents(year: currentYear, month: indexPath.section + 1)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let view = UIView()
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size))
        label.text = date.toString(dateFormat: "MMMM")
        label.textAlignment = .center
        label.textColor = .darkGray
        view.addSubview(label)
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size)
        return view
    }
    
    func getNameOfDay(index: Int) -> String {
        switch index {
        case 0:
            return "SUN"
        case 1:
            return "MON"
        case 2:
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            break
        }
        return ""
    }
    
    func getIndexDay(name: String) -> Int {
        switch name {
        case "Sun":
            return 0
        case "Mon":
            return 1
        case "Tue":
            return 2
        case "Wed":
            return 3
        case "Thu":
            return 4
        case "Fri":
            return 5
        case "Sat":
            return 6
        default:
            break
        }
        return 0
    }
    
    func getDaysView(forCell cell: UICollectionViewCell, with indexPath: IndexPath) -> UIView {
        let indexDayInMouth = getIndexDay(name: getFirstDayInMouth(mouth: indexPath.section + 1))
        
        let view = UIView()
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size))
        label.textAlignment = .center
        if indexPath.row - 7 < 0 {
            label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            label.text = getNameOfDay(index: indexPath.row)
        } else {
            if indexPath.row < 7 + indexDayInMouth {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: IndexPath(row: indexPath.row, section: indexPath.section))
            }
            
            label.font = UIFont.systemFont(ofSize: 12)
            label.text = String(indexPath.row - 6 - indexDayInMouth)
        }
        if currentMonth == indexPath.section + 1 && currentDay == indexPath.row - 6 - indexDayInMouth {
            view.backgroundColor = .blue
            view.layer.cornerRadius = label.frame.size.width/2
            label.textColor = .white
        } else {
            view.backgroundColor = .clear
            label.textColor = .darkGray
        }
        view.addSubview(label)
        return view
    }
}
