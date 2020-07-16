//
//  TopRoundView.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

@IBDesignable
class TopRoundView: UIView {

    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: cornerRadious, height: cornerRadious))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }

}
