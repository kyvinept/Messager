//
//  CalendarViewController.swift
//  Messager
//
//  Created by Silchenko on 28.11.2018.
//

import UIKit

protocol CalendarViewControllerDelegate: class {
    func didTappedCancelButton(viewController: CalendarViewController)
}

class CalendarViewController: UIViewController {

    weak var delegate: CalendarViewControllerDelegate?
    
    @IBOutlet private weak var currentNumber: UILabel!
    @IBOutlet private weak var currentMounth: UILabel!
    @IBOutlet private weak var currentYear: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }

}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dateComponents = DateComponents(year: 2018, month: section + 1)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //if kind == UICollectionElementKindSectionHeader {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! UICollectionReusableView
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundView = getBackgroundView(forCell: cell, with: indexPath)
        return cell
    }
    
    private func getBackgroundView(forCell cell: UICollectionViewCell, with indexPath: IndexPath) -> UIView {
        let view = UIView()
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size))
        label.textAlignment = .center
        label.text = String(indexPath.row + 1)
        if currentMonth == indexPath.section + 1 && currentDay == indexPath.row + 1 {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6, height: collectionView.frame.width/6)
    }
}

private extension CalendarViewController {
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.backgroundViewTapped))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func backgroundViewTapped() {
        delegate?.didTappedCancelButton(viewController: self)
    }
}
