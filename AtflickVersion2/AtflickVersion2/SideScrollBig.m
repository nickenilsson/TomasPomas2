//
//  SideScrollBig.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "SideScrollBig.h"

@implementation SideScrollBig

-(void) prepareLayout
{
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    CGFloat itemHeight = collectionViewBounds.size.height;
    CGFloat itemWidth = collectionViewBounds.size.width*0.95;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    CGFloat insetVertical = (collectionViewBounds.size.width - itemWidth) / 2;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, insetVertical, 0, insetVertical);
    self.minimumInteritemSpacing = 10;
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

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect collectionViewBounds = newBounds;
    
    CGFloat itemHeight = collectionViewBounds.size.height;
    CGFloat itemWidth = collectionViewBounds.size.width*0.85;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);

    
    return YES;
}



@end
