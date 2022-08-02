//
//  HomeHorizontalFlowLayout.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/08.
//

import UIKit

final class HomeHorizontalFlowLayout: UICollectionViewFlowLayout {
    var pageWidth: CGFloat {
        return (self.itemSize.width+self.minimumInteritemSpacing)*2
    }
    
    var flickVelocity: CGFloat {
        return 1.0
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        var resultContentOffset = proposedContentOffset
        
        if let collectionView = self.collectionView {
            let rawPageValue = collectionView.contentOffset.x / self.pageWidth
            let currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue)
            let nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue)
            
            let pannedLessThanAPage = abs(1 + currentPage - rawPageValue) > 0.5
            let flicked = abs(velocity.x) > self.flickVelocity
            
            if (pannedLessThanAPage && flicked) == true {
                resultContentOffset.x = nextPage * self.pageWidth
            } else {
                resultContentOffset.x = round(rawPageValue) * self.pageWidth
            }
            resultContentOffset.x -= self.collectionView?.contentInset.left ?? 0
        }
        
        return resultContentOffset
    }
}
