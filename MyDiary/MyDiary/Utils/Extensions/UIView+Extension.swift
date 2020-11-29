//
//  UIView+Extension.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation
import UIKit

extension UIView{
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func roundedView() {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }
    
    func applyBorder(color: UIColor, width: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func applyCornerRadius(radius: CGFloat = 15.0) {
        layoutIfNeeded()
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyShadow(color: UIColor, opacity: Float = 0.5, radius: CGFloat = 2) {
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
