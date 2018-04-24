//
//  HUDView.swift
//  v2ex
//
//  Created by wjb on 2018/4/19.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class HUDView: UIView {

    var text = ""
    var hudType = HudType.loading

    enum HudType {
        case loading
        case finish
    }

    class func hud(inView view: UIView, hudType: HudType) -> HUDView {
        let hudView = HUDView(frame: view.bounds)
        hudView.isOpaque = false
        hudView.hudType = hudType

        view.addSubview(hudView)
        view.isUserInteractionEnabled = false

        hudView.show()
        return hudView
    }

    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96

        let boxRect = CGRect(x: round((frame.width - boxWidth) / 2), y: round((frame.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)

        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()

        switch hudType {
        case .loading:
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.center = CGPoint(x: boxRect.midX, y: boxRect.midY - indicator.frame.height / 2)
            indicator.startAnimating()
            self.addSubview(indicator)
        case .finish:
            let image = UIImage(named: "Checkmark")!
            let imagePoint = CGPoint(x: boxRect.midX - round(image.size.width / 2), y: boxRect.midY - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imagePoint)
        }

        let attribs = [
            NSAttributedStringKey.font: UIFont(name: "PingFang SC", size: 16)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: attribs)
        let textPoint = CGPoint(x: boxRect.midX - round(textSize.width / 2), y: boxRect.midY - round(textSize.height / 2) + boxHeight / 4)
        text.draw(at: textPoint, withAttributes: attribs)
    }

    func show() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.alpha = 1
            self.transform = .identity
        }) { _ in
            self.superview?.isUserInteractionEnabled = true

            switch self.hudType {
            case .finish:
                self.removeFromSuperview()
            default:
                break
            }
        }
    }

}
