//
//  ContentOverviewViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/30/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"

@interface ContentOverviewViewController : ContentDisplayView

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (strong, nonatomic) NSMutableArray *itemsCollection1;

@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (strong, nonatomic) NSMutableArray *itemsCollection2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView3;
@property (strong, nonatomic) NSMutableArray *itemsCollection3;

@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView4;
@property (strong, nonatomic) NSMutableArray *itemsCollection4;

@end

