//
//  ListViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/30/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "ListViewController.h"
#import "ArrayDataSource.h"
#import "BigBannerCell.h"
#import "ListCell.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface ListViewController ()

@property (strong, nonatomic) ArrayDataSource *dataSource;

@end

@implementation ListViewController

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
    [self.delegate setContainerScrollEnabled:NO];
    for (NSString* item in self.items) {
        NSLog(@"item: %@", item);
    }
    
    [self.collectionView registerNib:[ListCell nib] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    CellConfigureBlock cellConfiguration = ^(BigBannerCell *cell, NSString *item){
        cell.label.text = item;
    };
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.items cellIdentifier:cellIdentifier configureCellBlock:cellConfiguration];
    self.collectionView.dataSource = self.dataSource;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
