//
//  UIViewController+constraints.swift
//  ShareScreen
//
//  Created by TIAGO ALMEIDA DE OLIVEIRA on 11/08/20.
//  Copyright © 2020 TIAGO ALMEIDA DE OLIVEIRA. All rights reserved.
//

import UIKit

enum AnchorConstraint {
    case top
    case leading
    case trailing
    case bottom
    case centerX
    case centerY
}

extension UIView {
    func snapAllConstraints(toView view: UIView, horizontalDistance: CGFloat = 0, verticalDistance: CGFloat = 0) {
        snapTop(toView: view, distance: verticalDistance)
        snapLeading(toView: view, distance: horizontalDistance)
        snapTrailing(toView: view, distance: -horizontalDistance)
        snapBottom(toView: view, distance: -verticalDistance)
    }
    
    func snapTop(toView view: UIView, anchor: AnchorConstraint = .top, distance: CGFloat = 0) {
        if anchor == .top {
            topAnchor.constraint(equalTo: view.topAnchor, constant: distance).isActive = true
        } else if anchor == .bottom {
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: distance).isActive = true
        }
    }
    
    func snapLeading(toView view: UIView, anchor: AnchorConstraint = .leading, distance: CGFloat = 0) {
        if anchor == .leading {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: distance).isActive = true
        } else if anchor == .trailing {
            leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: distance).isActive = true
        }
    }
    
    func snapTrailing(toView view: UIView, anchor: AnchorConstraint = .trailing, distance: CGFloat = 0) {
        if anchor == .trailing {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: distance).isActive = true
        } else if anchor == .leading {
            trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: distance).isActive = true
        }
    }
    
    func snapBottom(toView view: UIView, anchor: AnchorConstraint = .bottom, distance: CGFloat = 0) {
        if anchor == .bottom {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: distance).isActive = true
        } else if anchor == .top {
            bottomAnchor.constraint(equalTo: view.topAnchor, constant: distance).isActive = true
        }
    }
}
