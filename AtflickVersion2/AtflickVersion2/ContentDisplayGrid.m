//
//  ContentDisplayGrid.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/1/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "ContentDisplayGrid.h"
#import "ArrayDataSource.h"
#import "BigBannerCell.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface ContentDisplayGrid ()

@property (strong, nonatomic) ArrayDataSource *dataSource;

@end

@implementation ContentDisplayGrid

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[BigBannerCell nib] forCellWithReuseIdentifier:cellIdentifier];
    CellConfigureBlock cellConfiguration = ^(BigBannerCell *cell, NSString *item){
        cell.label.text = item;
    };
    self.dataSource = [[ArrayDataSource alloc]initWithItems:self.items cellIdentifier:cellIdentifier configureCellBlock:cellConfiguration];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
