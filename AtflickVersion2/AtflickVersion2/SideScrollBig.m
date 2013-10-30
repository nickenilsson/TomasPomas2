//
//  SideScrollBig.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "SideScrollBig.h"

@interface SideScrollBig ()

@end

@implementation SideScrollBig

-(void) prepareLayout
{
    
    CGRect collectionViewBounds = self.collectionView.bounds;
    
    CGFloat itemHeight = collectionViewBounds.size.height;
    CGFloat itemWidth = collectionViewBounds.size.width;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;

}

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



@end
