//
//  SnappyFlowLayout.swift
//  CustomPath
//
//  Created by MinhHieu on 13/02/2025.
//

import Foundation
import UIKit

class SnappyFlowLayout: UICollectionViewFlowLayout {
    let activeDistance: CGFloat = 200
    let zoomFator: CGFloat = 0.3
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 40
    }
    
    private func getCollection() -> UICollectionView {
        guard let collectionView = collectionView else {
            fatalError("Fail Collection")
        }
        return collectionView
    }
    
    override func prepare() {
        let collectionView = getCollection()
        let width = collectionView.frame.width * 0.6
        let height = collectionView.frame.height * 0.6
        itemSize = CGSize(width: width, height: height)
        
        let verticalInset = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - height) / 2
        
        let horizotalInset = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - width) / 2
        
        sectionInset = UIEdgeInsets(top: verticalInset, left: horizotalInset, bottom: verticalInset, right: horizotalInset)
        super.prepare()

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let collectionView = getCollection()
        let recAttrs = super.layoutAttributesForElements(in: rect)!.map{ $0.copy() as! UICollectionViewLayoutAttributes}
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        for attrs in recAttrs where attrs.frame.intersects(visibleRect) {
            let distance = visibleRect.minX - attrs.center.x
            let normalizeDistance = distance / activeDistance
            
            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFator * (1 - normalizeDistance.magnitude)
                attrs.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attrs.zIndex = Int(zoom.rounded())
            }
        }
        
        return recAttrs
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let collectionView = getCollection()
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        
        guard let rectAttrs = super.layoutAttributesForElements(in: targetRect) else {
            return .zero
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttrs {
            let itemHorizontalCenter = layoutAttributes.center.x
            
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let collectionView = getCollection()
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView.bounds.size
        
        return context
    }
}
