//
//  OverviewController2.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"

@interface OverviewController2 : ContentDisplayView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView3;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView4;

@property (strong, nonatomic) NSMutableArray *itemsCollection1;
@property (strong, nonatomic) NSMutableArray *itemsCollection2;
@property (strong, nonatomic) NSMutableArray *itemsCollection3;
@property (strong, nonatomic) NSMutableArray *itemsCollection4;

@end
