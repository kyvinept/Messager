//
//  UIView.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

extension UIView {
    func loadViewFromNib(withNibName nibName: String) -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
