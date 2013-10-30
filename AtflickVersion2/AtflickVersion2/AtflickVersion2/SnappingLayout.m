//
//  SnappingLayout.m
//  CollectionViewTest
//
//  Created by Tomas Nilsson on 9/17/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "SnappingLayout.h"

@implementation SnappingLayout

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    CGFloat offsetAdjustment = MAXFLOAT;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemOrigin = layoutAttributes.frame.origin.x;
        
        if (ABS(itemOrigin - proposedContentOffset.x) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOrigin - proposedContentOffset.x;
        }
    }    
    if(proposedContentOffset.x == self.collectionView.contentSize.width - self.collectionViewContentSize.width){
    }
    CGPoint newOffset;
    if(proposedContentOffset.x >= self.collectionViewContentSize.width - self.collectionView.bounds.size.width){
        newOffset = proposedContentOffset;
    }else{
        CGFloat insetLeft = self.sectionInset.left;
        newOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment - insetLeft, proposedContentOffset.y);
    }
    return newOffset;
}





@end
