//
//  SkipView.swift
//  TestUIAlertController
//
//  Created by He Wu on 11/5/17.
//  Copyright © 2017 He Wu. All rights reserved.
//

import Foundation
import UIKit

enum SkipAlertViewButtonType: NSInteger{
    case Filled
    case Bordered
}

extension UIButton{
    func setBackgroundColor(color: UIColor, state: UIControlState){
        self.setBackgroundImage(self.imageWithColor(color: color), for: state)
    }
    func imageWithColor(color: UIColor)->UIImage{
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color as! CGColor)
        context.addRect(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

class SkipAlertTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textContainerInset = UIEdgeInsets.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if __CGSizeEqualToSize(self.bounds.size, self.instrinsicContentSize()){
            self.invalidateIntrinsicContentSize()
        }
    }
    
    private func instrinsicContentSize() -> CGSize{
        if (self.text != nil) {
            return self.contentSize
        } else {
            return CGSize.zero
        }
    }
}

class SkipAlertViewButton: UIButton{
    var type: SkipAlertViewButtonType
    var cornerRadius: CGFloat
    
    func buttonWithTpe(buttonType: UIButtonType)->Any{
        return super.buttonType
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit()->Void{
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        
        self.layer.borderWidth = 1.0
        
        self.cornerRadius = 4.0
        self.clipsToBounds = true
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .disabled)
        
        self.tintColorDidChange()
    }
    
    func setHidden(hidden: Bool)->Void{
        super.isHidden = hidden
        self.invalidateIntrinsicContentSize()
    }
    
    func setEnabled(enabled: Bool) ->Void{
        super.isEnabled = enabled
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        if self.type == SkipAlertViewButtonType.Filled {
            if self.isEnabled {
                self.setBackgroundColor(color: self.tintColor, state: .normal)
            }
        }else {
            self.setTitleColor(self.tintColor, for: .normal)
        }
     
        self.layer.borderColor = self.tintColor.cgColor
        self.setNeedsDisplay()
    }
    
    func CornerRadius()->CGFloat{
        return self.layer.cornerRadius
    }
    
    func setCornerRadius(cornerRadius: CGFloat)->Void{
        self.layer.cornerRadius = cornerRadius
    }
    
    func intrinsicContentSize()->CGSize{
        if self.isHidden {
            return CGSize.zero
        }
        return CGSize(width: super.intrinsicContentSize.width+12.0, height: 30.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderColor = self.tintColor.cgColor
        
        if self.type == SkipAlertViewButtonType.Bordered {
            self.layer.borderWidth = 1.0
        } else {
            self.layer.borderWidth = 0.0
        }
        
        if self.state == UIControlState.highlighted {
            self.layer.backgroundColor = self.tintColor.cgColor
        } else {
            if self.type == SkipAlertViewButtonType.Bordered {
                self.layer.backgroundColor = nil
                self.setTitleColor(self.tintColor, for: .normal)
            } else {
                
            }
        }
    }
}

class SkipView: UIView {
    //MARK: Properties
    var titleLable: UILabel
    var messageTextView: UITextView
    var contentView: UIView
    
    var buttonTitleFont: UIFont
    var cancelButtonTitleFont: UIFont
    var destructiveButtonTitleFont: UIFont
    
    var buttonColor: UIColor
    var buttonTitleColor: UIColor
    var cancelButtonColor: UIColor
    var cancelButtonTitleColor: UIColor
    var destructiveButtonColor: UIColor
    var destructiveBUttonTitleColor: UIColor
    
    var buttonCornerRadius: CGFloat
    var maximumWidth: CGFloat
    
    var alertBackgroundView: UIView
    var backgroundViewVerticalCenteringConstraint: NSLayoutConstraint
    
    var actionButtons: NSArray
    var textFields: NSArray
    
    var alertBackgroundWidthConstraint: NSLayoutConstraint
    var contentViewContainerView: UIView
    var textFieldContainerView: UIView
    var actionButtonContainerView: UIView
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.maximumWidth = 480.0
        
        alertBackgroundView = UIView(frame: CGRect.zero)
        self.alertBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.alertBackgroundView.backgroundColor = UIColor.white
        self.alertBackgroundView.layer.cornerRadius = 6.0
        self.addSubview(alertBackgroundView)
        
        titleLable = UILabel(frame: CGRect.zero)
        self.titleLable.translatesAutoresizingMaskIntoConstraints = false
        self.titleLable.numberOfLines = 2
        self.titleLable.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        self.titleLable.textAlignment = NSTextAlignment.center
        self.titleLable.textColor = UIColor.gray
        self.titleLable.text = NSLocalizedString("Title Label", comment: "")
        self.alertBackgroundView.addSubview(self.titleLable)
        
        messageTextView = SkipAlertTextView(frame: .zero, textContainer: nil)
        self.messageTextView.translatesAutoresizingMaskIntoConstraints = false
        self.messageTextView.backgroundColor = UIColor.clear
        self.messageTextView.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: UILayoutConstraintAxis.vertical)
        self.messageTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.messageTextView.isEditable = false
        self.messageTextView.textAlignment = NSTextAlignment.center
        self.messageTextView.textColor = UIColor.darkGray
        self.messageTextView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.messageTextView.text = NSLocalizedString("Message Text View", comment: "")
        self.messageTextView.addSubview(self.messageTextView)
        
        contentViewContainerView = UIView(frame: CGRect.zero)
        self.contentViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.setContentCompressionResistancePriority(.required, for: .vertical)
        self.alertBackgroundView.addSubview(self.contentViewContainerView)
        
        textFieldContainerView = UIView(frame: CGRect.zero)
        self.textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
        self.alertBackgroundView.addSubview(self.textFieldContainerView)
        
        actionButtonContainerView = UIView(frame: CGRect.zero)
        self.actionButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.actionButtonContainerView.setContentHuggingPriority(.required, for: .vertical)
        self.alertBackgroundView.addSubview(self.actionButtonContainerView)
        
        self.addConstraint(NSLayoutConstraint(
            item: self.alertBackgroundView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0))
        
        var alertBackgroundViewWidth: CGFloat = min(
            (UIApplication.shared.keyWindow?.bounds.width)!,
            (UIApplication.shared.keyWindow?.bounds.height)!)*0.8
        
        if alertBackgroundViewWidth > self.maximumWidth {
            alertBackgroundViewWidth = self.maximumWidth
        }
        
        alertBackgroundWidthConstraint = NSLayoutConstraint(
            item: self.alertBackgroundView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0.0,
            constant: alertBackgroundViewWidth)
        
        self.addConstraint(self.alertBackgroundWidthConstraint)
        
        backgroundViewVerticalCenteringConstraint = NSLayoutConstraint(
            item: self.alertBackgroundView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        self.addConstraint(self.backgroundViewVerticalCenteringConstraint)
        
        self.addConstraint(NSLayoutConstraint(
            item: self.alertBackgroundView,
            attribute: .height,
            relatedBy: .lessThanOrEqual,
            toItem: self,
            attribute: .height,
            multiplier: 0.9,
            constant: 0.0))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "titleLable",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["titleLable": titleLable]))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "messageTextView",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["messageTextView": messageTextView]))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "contentViewContainerView",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["contentViewContainerView": contentViewContainerView]))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "textFieldContainerView",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["textFieldContainerView": textFieldContainerView]))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "actionButtonContainerView",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["actionButtonContainerView": actionButtonContainerView]))
        
        self.alertBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "titleLabel,messageTextView,contentViewContainerView,textFieldContainerView,actionButtonContainerView",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: [
                "titleLable": titleLable,
                "messageTextView": messageTextView,
                "contentViewContainerView": contentViewContainerView,
                "textFieldContainerView": textFieldContainerView,
                "actionButtonContainerView": actionButtonContainerView
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Functions
    
    
    //MARK: Private Funtions
    
}
