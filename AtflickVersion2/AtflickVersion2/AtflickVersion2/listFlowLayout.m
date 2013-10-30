//
//  ListFlowLayout.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "ListFlowLayout.h"

@interface ListFlowLayout ()

@property (nonatomic) CGFloat itemHeight;

@end

@implementation ListFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void) prepareLayout
{
    self.sectionInset = UIEdgeInsetsMake(10, 0, 100, 0);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.itemHeight = screenBounds.size.height / 8;
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.itemHeight);
}
-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    self.itemSize = CGSizeMake(newBounds.size.width, self.itemHeight);
    return YES;
}

@end
