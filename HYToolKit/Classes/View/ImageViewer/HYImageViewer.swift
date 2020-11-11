//
//  HYImageViewer.swift
//  HYToolKit
//
//  Created by HY on 2019/10/14.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit
import Kingfisher

/// 图片查看器
public class HYImageViewer: UIView {
  
  private enum ImageType {
    case url, image
  }
  
  private var imageType: ImageType = .image
  private var imageUrls: [String] = []
  private var imageObjs: [UIImage?] = []
  private var imageMarks: [String]? = []
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    layout.itemSize = UIScreen.main.bounds.size
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    
    let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
    cv.isPagingEnabled = true
    cv.backgroundColor = UIColor.clear
    cv.showsHorizontalScrollIndicator = false
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()
  
  private lazy var closeBtn: UIButton = {
    let btn = UIButton(frame: CGRect(x: 15, y: UIApplication.shared.statusBarFrame.size.height+15, width: 35, height: 35))
    btn.setImage(UIImage(named: "image_close_icon", in: Bundle(for: Self.self), compatibleWith: nil), for: .normal)
    btn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
    btn.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    btn.layer.cornerRadius = 17
    return btn
  }()
  
  private lazy var textLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    label.center = CGPoint(x: self.bounds.size.width/2, y: self.closeBtn.center.y)
    label.backgroundColor = UIColor.gray.withAlphaComponent(0.2);
    label.layer.cornerRadius = 17
    label.layer.masksToBounds = true
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
  }
  
  /// 使用 图片地址 数组初始化
  /// - Parameter URLs: 图片url string地址
  /// - Parameter marks: 描述文字
  public convenience init(with URLs: [String], marks: [String]? = nil) {
    self.init(frame: CGRect.zero)
    self.imageType = .url
    self.imageUrls = URLs
    self.imageMarks = marks
    self.setupUI()
  }
  
  /// 使用 图片对象 数组初始化
  /// - Parameter images: 图片对象
  /// - Parameter marks: 描述文字
  public convenience init(with images: [UIImage?], marks: [String]? = nil) {
    self.init(frame: CGRect.zero)
    self.imageType = .image
    self.imageObjs = images
    self.imageMarks = marks;
    self.setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor.black
    
    self.collectionView.register(HYImageViewerCell.self, forCellWithReuseIdentifier: "HYImageViewerCell")
    self.addSubview(self.collectionView)
    self.collectionView.reloadData()
    
    self.addSubview(self.textLabel)
    self.addSubview(self.closeBtn)
    
    self.isHidden = true
  }
  
  // MARK: Action
  /// 关闭按钮操作
  @objc private func clickCloseBtn() {
    self.hide(animated: true)
  }
}

// MARK: CollectionViewDelegateSource
extension HYImageViewer: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let cell = cell as! HYImageViewerCell
    cell.scrollView.zoomScale = 1.0
  }
}

// MARK: CollectionViewDataSource
extension HYImageViewer: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.imageType == .image ? self.imageObjs.count : self.imageUrls.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HYImageViewerCell", for: indexPath) as! HYImageViewerCell
    cell.singleTapCallback = { [weak self] in
      self?.hide(animated: true)
    }
    
    var mark: String? = nil
    if let marks = self.imageMarks, marks.count > indexPath.row{
      mark = marks[indexPath.row]
    }
    
    if (self.imageType == .image) {
      cell.fill(image: self.imageObjs[indexPath.row], mark: mark)
    } else {
      cell.fill(imageUrl: self.imageUrls[indexPath.row], mark: mark)
    }
    return cell
  }
}

// MARK: ScrollViewDelegate
extension HYImageViewer: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let index: Int = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width)
    self.textLabel.text = "\(index+1) / \(self.imageType == .image ? self.imageObjs.count : self.imageUrls.count)"
  }
}

// MARK: Public
public extension HYImageViewer {
  
  /// 展示图片查看器
  /// - Parameter index: 默认的位置，默认0
  /// - Parameter animated: 需要动画，默认true
  func show(index: Int = 0, animated: Bool = true) {
    let total = self.collectionView.numberOfItems(inSection: 0)
    if total > 0{
      self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
      self.textLabel.text = "\(index+1) / \(total)"
      self.textLabel.isHidden = false
    } else {
      self.textLabel.isHidden = true
    }
    
    UIApplication.shared.keyWindow?.addSubview(self)
    self.isHidden = false
    
    if animated {
      self.alpha = 0
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.alpha = 1
      }
    }
  }
  
  /// 隐藏图片查看器
  /// - Parameter animated: 需要动画，默认true
  func hide(animated: Bool = true) {
    if animated {
      UIView.animate(withDuration: 0.3, animations: {
        self.alpha = 0
      }) { (finished) in
        self.removeFromSuperview()
      }
    } else {
      self.removeFromSuperview()
    }
  }
}


// -------------------------------------------------
// MARK: - HYImageViewerCell
fileprivate class HYImageViewerCell: UICollectionViewCell, UIScrollViewDelegate {
  lazy var scrollView: UIScrollView = {
    let sv = UIScrollView(frame: self.bounds)
    sv.contentSize = CGSize.zero
    sv.delegate = self
    sv.maximumZoomScale = 3.0
    sv.showsVerticalScrollIndicator = false
    sv.showsHorizontalScrollIndicator = false
    
    let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapAction(_:)))
    doubleTap.numberOfTapsRequired = 2
    sv.addGestureRecognizer(doubleTap)
    
    let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapAction(_:)))
    singleTap.require(toFail: doubleTap)
    sv.addGestureRecognizer(singleTap)
    
    let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(_:)))
    sv.addGestureRecognizer(longPress)
    
    return sv
  }()
  
  private lazy var imageView: UIImageView = {
    let view = UIImageView.init(frame: self.bounds)
    view.contentMode = .scaleAspectFit
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private lazy var markView: UIView = {
    let view = UIView.init()
    view.backgroundColor = UIColor.black(alpha: 0.7)
    return view
  }()
  
  private lazy var markLabel: UILabel = {
    let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: self.bounds.width-20, height: 0))
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor.white
    return label
  }()
  
  public var singleTapCallback: (()->Void)?
  
  // MARK: init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(self.scrollView)
    self.scrollView.addSubview(self.imageView)
    self.contentView.addSubview(self.markView)
    self.markView.addSubview(self.markLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: delegate
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    // 让图放大以后也保持在中间
    let x = scrollView.contentSize.width/2
    let y = scrollView.contentSize.height > scrollView.bounds.size.height ? scrollView.contentSize.height/2 : scrollView.center.y
    self.imageView.center = CGPoint(x: x, y: y)
  }
  
  // MARK: action
  /// 双击&单击，双击放大，单击隐藏
  @objc func doubleTapAction(_ ges: UITapGestureRecognizer) {
    if ges.state == .ended {
      if ges.numberOfTapsRequired == 2 { // 放大
        let scale: CGFloat = self.scrollView.zoomScale>1 ? 1 : 2
        self.scrollView.setZoomScale(scale, animated: true)
      } else if ges.numberOfTapsRequired == 1 { // 告诉外侧要关闭了
        self.singleTapCallback?()
      }
    }
  }
  
  /// 长按保存
  @objc func longPressAction(_ ges: UILongPressGestureRecognizer) {
    if let image = self.imageView.image, ges.state == .began {
      let sheet = UIAlertController(title: nil, message: "更多操作", preferredStyle: .actionSheet)
      sheet.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      }))
      sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
      UIApplication.shared.keyWindow?.rootViewController?.present(sheet, animated: true, completion: nil)
    }
  }
  
  // MARK: private
  /// 处理图片下的文字展示，如果没有文字会隐藏
  private func dealMark(_ mark: String?) {
    guard let text = mark, text.count > 0 else {
      self.markView.isHidden = true
      return
    }
    
    self.markLabel.text = text
    self.markView.isHidden = false
    
    let height = NSString(string: text).boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil).size.height + 1
    self.markLabel.frame = CGRect(x: 10, y: 10, width: self.bounds.width-20, height: height)
    
    var safeBottom: CGFloat = 0
    if #available(iOS 11.0, *) {
      if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
        safeBottom = bottom
      }
    }
    self.markView.frame = CGRect(x: 0, y: self.bounds.height-height-20, width: self.bounds.width, height: height + 20 + safeBottom)
  }
  
  /// 调整imageview的位置
  private func resizeImageView() {
    if let size = self.imageView.image?.size,
      size.width.isNaN == false,
      size.height.isNaN == false {
      
      self.imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width * size.height / size.width)
      if (size.height < self.bounds.height) {
        self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
      } else {
        self.scrollView.contentSize = CGSize(width: self.bounds.width, height: self.imageView.frame.height);
      }
    }
  }
  
  // MARK: 填充数据
  /// 使用image对象填充数据
  func fill(image: UIImage?, mark: String?) {
    self.imageView.image = image
    self.resizeImageView()
    self.dealMark(mark)
  }
  
  /// 使用图片url填充数据
  func fill(imageUrl: String, mark: String?) {
    self.imageView.image = nil
    self.imageView.kf.indicatorType = .activity
    self.imageView.kf.setImage(
      with: URL(string: imageUrl),
      options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ]
    ) { [weak self] result in
      switch result {
      case .success(let value):
          self?.resizeImageView()
          print("Task done for: \(value.source.url?.absoluteString ?? "")")
      case .failure(let error):
          print("Job failed: \(error.localizedDescription)")
      }
    }
    self.dealMark(mark)
  }
  
}
