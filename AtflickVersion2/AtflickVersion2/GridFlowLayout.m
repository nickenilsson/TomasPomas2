//
//  GridFlowLayout.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "GridFlowLayout.h"

@interface GridFlowLayout()

@property (nonatomic) BOOL itemSizeHasBeenSet;

@end

@implementation GridFlowLayout


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) prepareLayout
{
    self.sectionInset = UIEdgeInsetsMake(20, 20, 60, 20);
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat itemWidth = screenSize.size.width/5.2;
    CGFloat itemHeight = itemWidth * 1.2;
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.minimumInteritemSpacing = 15;
    self.minimumLineSpacing = 30;
}

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    return YES;
}

@end
