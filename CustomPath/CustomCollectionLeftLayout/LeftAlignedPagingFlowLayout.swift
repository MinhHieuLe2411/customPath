//
//  LeftAlignedPagingFlowLayout.swift
//  CustomPath
//
//  Created by MinhHieu on 11/02/2025.
//

import UIKit

class LeftAlignedPagingFlowLayout: UICollectionViewFlowLayout {
    let scaleFactor: CGFloat = 0.25 // Độ phóng to tối đa
    let minScale: CGFloat = 0.7 // Kích thước nhỏ nhất cho item không phải target
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Thiết lập layout cho từng item
        let itemWidth: CGFloat = collectionView.bounds.width * 0.7 // 70% chiều rộng của collectionView
        let itemHeight: CGFloat = collectionView.bounds.height * 0.9 // 90% chiều cao của collectionView
        let spacing: CGFloat = 10 // Khoảng cách giữa các item
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Căn lề trái
        minimumLineSpacing = spacing
        scrollDirection = .horizontal // Cuộn ngang
        
        // Cấu hình tốc độ cuộn
        collectionView.decelerationRate = .fast
    }
    
    // 📌 Scale các item dựa trên khoảng cách tới center của CollectionView
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect)
        else {
            return nil
        }

//        let collectionViewCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        let collectionViewCenterX = collectionView.bounds.midX

        for attributes in attributesArray {
            let distance = abs(attributes.center.x - collectionViewCenterX)
            
            let normalizedDistance = distance / collectionView.bounds.width
            
            // Tính scale
            let scale = max(minScale, 1 - (normalizedDistance * scaleFactor))
            
            // Tính vị trí Y để dịch cell nhỏ xuống đáy
//            let yOffset = (1 - scale) * attributes.size.height / 2
            
            // Giữ bottom của cell không thay đổi
            let originalY = attributes.frame.maxY
            let yOffset = (1 - scale) * attributes.size.height / 2
            attributes.frame.origin.y = originalY - attributes.size.height + yOffset
            
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return attributesArray
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true // Cập nhật lại layout khi scroll
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let pageWidth = itemSize.width + minimumLineSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        let currentPage = velocity.x > 0 ? ceil(approximatePage) : floor(approximatePage)
        
        let newX = currentPage * pageWidth
        return CGPoint(x: newX, y: proposedContentOffset.y)
    }
}

class RightAlignedPagingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let itemWidth: CGFloat = collectionView.bounds.width * 0.8
        let itemHeight: CGFloat = collectionView.bounds.height * 0.9
        let spacing: CGFloat = 10
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        minimumLineSpacing = spacing
        scrollDirection = .horizontal
        
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let pageWidth = itemSize.width + minimumLineSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        let currentPage = velocity.x > 0 ? ceil(approximatePage) : floor(approximatePage)
        
        // Đảm bảo item cuối không bị dính mép phải
        let maxOffset = max(0, collectionView.contentSize.width - collectionView.bounds.width)
        let newX = min((currentPage + 1) * pageWidth - collectionView.bounds.width + itemSize.width + 20, maxOffset)

        return CGPoint(x: newX, y: proposedContentOffset.y)
    }
}

class CenterHorizontalPagingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let itemWidth: CGFloat = collectionView.bounds.width * 0.8
        let itemHeight: CGFloat = collectionView.bounds.height * 0.9
        let spacing: CGFloat = 10
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        minimumLineSpacing = spacing
        scrollDirection = .horizontal
        
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        // Tính toán kích thước item bao gồm khoảng cách giữa các item
        let pageWidth = itemSize.width + minimumLineSpacing
        
        // Xác định trang gần nhất
        let approximatePage = collectionView.contentOffset.x / pageWidth
//        let currentPage = velocity.x > 0 ? ceil(approximatePage) : floor(approximatePage)
        let targetPage = round(approximatePage) // Làm tròn để tránh lỗi lệch nhẹ

        // Căn giữa item
        let centeredX = (targetPage * pageWidth) - ((collectionView.bounds.width - pageWidth - minimumLineSpacing) / 2)

        // Giới hạn `contentOffset` trong khoảng hợp lệ
        let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
        let targetX = min(max(centeredX, 0), maxOffset)

        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }
}

class TopAlignedPagingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let itemWidth: CGFloat = collectionView.bounds.width * 0.8
        let itemHeight: CGFloat = collectionView.bounds.height * 0.4
        let spacing: CGFloat = 10
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        minimumLineSpacing = spacing
        scrollDirection = .vertical
        
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        // Tính toán kích thước item bao gồm khoảng cách giữa các item
        let pageHeight = itemSize.height + minimumLineSpacing
        
        // Xác định trang gần nhất
        let approximatePage = collectionView.contentOffset.y / pageHeight
        let currentPage = velocity.y > 0 ? ceil(approximatePage) : floor(approximatePage)
//        let targetPage = round(approximatePage) // Làm tròn để tránh lỗi lệch nhẹ

        let newY = currentPage * pageHeight
        return CGPoint(x: proposedContentOffset.x, y: newY)
    }
}

class BottomAlignedPagingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let itemWidth: CGFloat = collectionView.bounds.width * 0.8
        let itemHeight: CGFloat = collectionView.bounds.height * 0.4
        let spacing: CGFloat = 10
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        minimumLineSpacing = spacing
        scrollDirection = .vertical
        
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        // Tính toán kích thước item bao gồm khoảng cách giữa các item
        let pageHeight = itemSize.height + minimumLineSpacing
        
        // Xác định trang gần nhất
        let approximatePage = collectionView.contentOffset.y / pageHeight
        let currentPage = velocity.y > 0 ? ceil(approximatePage) : floor(approximatePage)
//        let targetPage = round(approximatePage) // Làm tròn để tránh lỗi lệch nhẹ
        
        let maxOffset = max(0, collectionView.contentSize.height - collectionView.bounds.height)

//        let newY = currentPage * pageHeight
        
        let newY = min((currentPage + 1) * pageHeight - collectionView.bounds.height + itemSize.height + 20, maxOffset)

        return CGPoint(x: proposedContentOffset.x, y: newY)
    }
}

class CenterVerticalPagingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let itemWidth: CGFloat = collectionView.bounds.width * 0.8
        let itemHeight: CGFloat = collectionView.bounds.height * 0.4
        let spacing: CGFloat = 10
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        minimumLineSpacing = spacing
        scrollDirection = .vertical
        
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        // Tính toán kích thước item bao gồm khoảng cách giữa các item
        let pageHeight = itemSize.height + minimumLineSpacing
        
        // Xác định trang gần nhất
        let approximatePage = collectionView.contentOffset.y / pageHeight
//        let currentPage = velocity.y > 0 ? ceil(approximatePage) : floor(approximatePage)
        let targetPage = round(approximatePage) // Làm tròn để tránh lỗi lệch nhẹ
        
        // Căn giữa item
        let centeredY = (targetPage * pageHeight) - ((collectionView.bounds.height - pageHeight - minimumLineSpacing) / 2)

        // Giới hạn `contentOffset` trong khoảng hợp lệ
        let maxOffset = collectionView.contentSize.height - collectionView.bounds.height
        let targetY = min(max(centeredY, 0), maxOffset)

        return CGPoint(x: proposedContentOffset.x, y: targetY)
    }
}
