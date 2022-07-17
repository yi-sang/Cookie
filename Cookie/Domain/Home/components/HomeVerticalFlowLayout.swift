//
//  HomeVerticalFlowLayout.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/17.
//

import Foundation
import UIKit

final class HomeVerticalFlowLayout: UICollectionViewFlowLayout {
    var pageHeight: CGFloat {
        return (self.itemSize.height+self.minimumLineSpacing)*3
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
            let rawPageValue = collectionView.contentOffset.y / self.pageHeight
            let currentPage = (velocity.y > 0.0) ? floor(rawPageValue) : ceil(rawPageValue)
            let nextPage = (velocity.y > 0.0) ? ceil(rawPageValue) : floor(rawPageValue)
            
            let pannedLessThanAPage = abs(1 + currentPage - rawPageValue) > 0.5
            let flicked = abs(velocity.y) > self.flickVelocity
            
            if (pannedLessThanAPage && flicked) == true {
                resultContentOffset.y = nextPage * self.pageHeight
            } else {
                resultContentOffset.y = round(rawPageValue) * self.pageHeight
            }
            resultContentOffset.y -= self.collectionView?.contentInset.top ?? 0
        }
        
        return resultContentOffset
    }
}
