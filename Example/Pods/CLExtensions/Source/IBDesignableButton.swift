//
//  IBDesignableButton.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/10.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import UIKit

@IBDesignable open class IBDesignableButton: UIButton {

    enum TitleLabelStyle: Int {
        case top = 0
        case left = 1
        case bottom = 2
        case right = 3
    }
    
    @IBInspectable public var borderColor: UIColor = .clear
    @IBInspectable public var borderWidth: CGFloat = 0.0
    @IBInspectable public var cornerRadius: CGFloat = 0.0
    @IBInspectable public var leftPadding: CGFloat = 0.0
    @IBInspectable public var rightPadding: CGFloat = 0.0
    @IBInspectable public var labelSpacing: CGFloat = UIScreen.fitPlusScreen(value: 15)
    @IBInspectable public var resetEdge: Bool = false
    @IBInspectable public var titleLabelStyle: Int = TitleLabelStyle.right.rawValue
    @IBInspectable public var commitColor: UIColor = UIColor.black
    @IBInspectable public var disableColor: UIColor = UIColor.gray
    @IBInspectable public var canSubmit: Bool = false {
        didSet {
            isEnabled = canSubmit
            backgroundColor = canSubmit ? commitColor : disableColor
        }
    }
    
    public var timer: DispatchSourceTimer?
    public var countDownSeconds: Int = 0
    
    public override func draw(_ rect: CGRect) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = numberOfLines
        
        clipsToBounds = true
        
        if resetEdge {
            resetTitleLabelAndImageEdge()
        }
        
        super.draw(rect)
    }
    
    private func resetTitleLabelAndImageEdge() {
        guard let titleLabel = titleLabel, let text = titleLabel.text, let font = titleLabel.font else { return }
        
        let titleSize = text.size(withAttributes: [.font: font])
        let imageSize = self.imageRect(forContentRect: self.frame)
         
        var titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         
        switch (titleLabelStyle) {
        case TitleLabelStyle.top.rawValue:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + labelSpacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case TitleLabelStyle.left.rawValue:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + labelSpacing))
        case TitleLabelStyle.bottom.rawValue:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + labelSpacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case TitleLabelStyle.right.rawValue:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -labelSpacing)
        default:
            break
        }
         
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    deinit {
        stopTimer()
    }
}

extension IBDesignableButton {
    // MARK: 开始定时器
    public func startCountDown(downTitle: String, resetTitle: String, seconds: Int) {
        countDownSeconds = seconds
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.scheduleRepeating(deadline: DispatchTime.now(), interval: .seconds(1), leeway: .milliseconds(10))
        
        timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                self.countDownSeconds -= 1
                if self.countDownSeconds <= 0 {
                    self.canSubmit = true
                    self.stopTimer()
                    
                    self.setTitle(resetTitle, for: .normal)
                } else {
                    self.canSubmit = false
                    self.setTitle("\(downTitle): \(self.countDownSeconds)", for: .normal)
                }
            }
        })
        timer?.resume()
    }
    
    //MARK: 停止定时器
    private func stopTimer() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
}
