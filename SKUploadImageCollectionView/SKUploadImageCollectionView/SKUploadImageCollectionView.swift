//
//  SKUploadImageCollectionView.swift
//  SKUploadImageCollectionViewExample
//
//  Created by admin on 6/12/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation
import UIKit

class SKUploadImageCollectionView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uploadCollectionView: UICollectionView! {
        didSet {
            uploadCollectionView.delegate = self
            uploadCollectionView.dataSource = self
            uploadCollectionView.register(UINib.init(nibName: "SKUploadImageCollectionViewCell",
                                                     bundle: nil),
                                          forCellWithReuseIdentifier: "SKUploadImageCollectionViewCell")
        }
    }
    
    // MARK: - Properties
    
    private var isfirstTimeTransform: Bool = true
    var transformCellScale: CGAffineTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    var animationSpeed: TimeInterval = 0.2
    var horizontalPadding: CGFloat = 0
    var cellContentWidth: CGFloat = 0
    var cellContentHeight: CGFloat = 0
    var cellPadding: CGFloat = 10
    
    // MARK: - Function
    
    func registerNib(cellClass: AnyClass?, cellID: String) {
        uploadCollectionView.register(cellClass, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SKUploadImageCollectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cellContentWidth = uploadCollectionView.bounds.width*0.5
        cellContentHeight = uploadCollectionView.bounds.height
        horizontalPadding = (contentView.bounds.width - cellContentWidth)/2
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension SKUploadImageCollectionView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: Float = Float(cellContentWidth + cellPadding)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        if targetOffset > currentOffset {
            newTargetOffset = ceilf(Float(currentOffset) / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(Float(currentOffset) / pageWidth) * pageWidth
        }

        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width)
        }

        targetContentOffset.pointee.x = CGFloat(currentOffset)
        uploadCollectionView.setContentOffset(CGPoint(x: Int(newTargetOffset), y: 0), animated: true)

        let index = newTargetOffset / pageWidth

        if index == 0 {
            var cell = uploadCollectionView.cellForItem(at: IndexPath(item: Int(index), section: 0))

            UIView.animate(withDuration: animationSpeed) {
                cell?.transform = CGAffineTransform.identity
            }

            cell = uploadCollectionView.cellForItem(at: IndexPath(item: Int(index)+1, section: 0))
            UIView.animate(withDuration: animationSpeed) { [weak self] in
                guard let self = self else { return }
                cell?.transform = self.transformCellScale
            }
        } else {

            var cell = uploadCollectionView.cellForItem(at: IndexPath(item: Int(index), section: 0))
     
            UIView.animate(withDuration: animationSpeed) {
                cell?.transform = CGAffineTransform.identity
            }

            cell = uploadCollectionView.cellForItem(at: IndexPath(item: Int(index)-1, section: 0))
            UIView.animate(withDuration: animationSpeed) { [weak self] in
                guard let self = self else { return }
                cell?.transform = self.transformCellScale
            }

            cell = uploadCollectionView.cellForItem(at: IndexPath(item: Int(index)+1, section: 0))
            UIView.animate(withDuration: animationSpeed) { [weak self] in
                guard let self = self else { return }
                cell?.transform = self.transformCellScale
            }
        }
    }
}

// MARK: - UICollectionViewFlowLayout
extension SKUploadImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellContentWidth, height: cellContentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
    }
}

// MARK: - UICollectionViewDataSource
extension SKUploadImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = uploadCollectionView.dequeueReusableCell(withReuseIdentifier: "SKUploadImageCollectionViewCell", for: indexPath) as? SKUploadImageCollectionViewCell else { return UICollectionViewCell() }
        cell.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 0, height: 1), radius: 5, scale: true)
        if indexPath.row == 0 && isfirstTimeTransform {
            isfirstTimeTransform = false
        } else {
            cell.transform = transformCellScale
        }
        
        return cell
    }
}
