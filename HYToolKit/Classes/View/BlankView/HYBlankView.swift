//
//  HYBlankView.swift
//  HYToolKit
//
//  Created by HY on 2019/11/1.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

typealias HYBlankViewClickClosure = (() -> Void)

class HYBlankView: UIView {
  
  private lazy var contentView: UIView = {
    return UIView(frame: self.bounds)
  }()
  private(set) lazy var imageView: UIImageView = {
    return UIImageView(frame: CGRect.zero)
  }()
  private(set) lazy var titleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = NSTextAlignment.center
    label.textColor = UIColor.black
    return label
  }()
  private(set) lazy var detailLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = NSTextAlignment.center
    label.textColor = UIColor.lightGray
    label.numberOfLines = 0
    return label
  }()
  private(set) lazy var bottomBtn: UIButton = {
    let btn = UIButton(frame: CGRect.zero)
    btn.setBtnColor(titleColor: UIColor.white, backColor: UIColor.systemBlue, borderColor: nil, radius: 2, for: .normal)
    btn.setBtnColor(titleColor: UIColor.white, backColor: UIColor.systemBlue.withAlphaComponent(0.7), borderColor: nil, radius: 2, for: .highlighted)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    return btn
  }()
  
  private var callback: HYBlankViewClickClosure?
  
  init(frame: CGRect, image: UIImage?, text: String, detail: String?, btnText: String?, callback: HYBlankViewClickClosure? = nil) {
    super.init(frame: frame)
    
    self.callback = callback
    
    self.backgroundColor = UIColor.white
    self.addSubview(self.contentView)
    
    self.imageView.image = image
    self.imageView.contentMode = .scaleAspectFit
    self.contentView.addSubview(self.imageView)
    
    self.titleLabel.text = text
    self.contentView.addSubview(self.titleLabel)

    self.detailLabel.text = detail
    self.contentView.addSubview(self.detailLabel)
    
    self.bottomBtn.setTitle(btnText, for: .normal)
    self.contentView.addSubview(self.bottomBtn)
    
    self.defaultDisplay()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func defaultDisplay() {
    contentView.width = self.width-8*2
    
    let imageSize = imageView.image?.size
    if let width = imageSize?.width,
      let height = imageSize?.height,
      !width.isNaN, !height.isNaN {
      
      let maxWidth = contentView.width-30
      let imgW = width < maxWidth ? width : maxWidth
      let imgH = imgW / width * height
      imageView.frame = CGRect(x: 0, y: 0, width: imgW, height: imgH)
      imageView.centerX = contentView.width/2
    }
    
    if let text = titleLabel.text, text.count > 0 {
      titleLabel.isHidden = false
      let titleSize = titleLabel.sizeThatFits(CGSize(width: contentView.width-60, height: CGFloat.greatestFiniteMagnitude))
      titleLabel.frame = CGRect(x: 0, y: imageView.bottom+5, width: titleSize.width, height: titleSize.height)
      titleLabel.centerX = imageView.centerX
    } else {
      titleLabel.isHidden = true
      titleLabel.y = imageView.bottom
      titleLabel.height = 0.0
    }
    
    if let text = detailLabel.text, text.count > 0 {
      detailLabel.isHidden = false
      let detailSize = detailLabel.sizeThatFits(CGSize(width: contentView.width-50, height: CGFloat.greatestFiniteMagnitude))
      detailLabel.frame = CGRect(x: 0.0, y: titleLabel.bottom+3, width: detailSize.width, height: detailSize.height)
      detailLabel.centerX = imageView.centerX
    } else {
      detailLabel.isHidden = true
      detailLabel.y = titleLabel.bottom
      detailLabel.height = 0.0
    }
    
    if let text = self.bottomBtn.titleLabel?.text, text.count > 0 {
      bottomBtn.isHidden = false
      bottomBtn.frame = CGRect(x: 15, y: detailLabel.bottom+10, width: contentView.width-30, height: 40)
    } else {
      bottomBtn.y = detailLabel.bottom
      bottomBtn.height = 0.0
      bottomBtn.isHidden = true
    }
    
    self.contentView.height = bottomBtn.bottom
    self.contentView.center = CGPoint(x: self.width/2, y: self.height/2)
  }
}

// MARK: - public
extension HYBlankView {
  
}
