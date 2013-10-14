//
//  SideScrollLayoutSmall.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "SideScrollLayoutSmall.h"

@interface SideScrollLayoutSmall ()

@property (nonatomic) CGSize itemSize;

@end

@implementation SideScrollLayoutSmall

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void) prepareLayout
{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.minimumInteritemSpacing = 10;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    CGFloat itemHeight = collectionViewBounds.size.height;
    CGFloat itemWidth = itemHeight*0.8;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
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
