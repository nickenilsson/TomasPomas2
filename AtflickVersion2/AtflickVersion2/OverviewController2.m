//
//  OverviewController2.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/11/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "OverviewController2.h"

#import <QuartzCore/QuartzCore.h>
#import "ArrayDataSource.h"
#import "BigBannerCell.h"
#import "SideScrollLayoutSmall.h"
#import "SideScrollBig.h"

static NSString * const cellIdentifierBanner = @"cellIdentifierBanner";
static NSString * const cellIdentifierRegular = @"cellIdentifierRegular";

@interface OverviewController2 ()

@property (strong, nonatomic) ArrayDataSource *dataSourceCollection1;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection2;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection3;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection4;

@end

@implementation OverviewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillLayoutSubviews
{
    self.scrollView.contentSize = self.contentView.frame.size;

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    self.itemsCollection1 = [NSMutableArray arrayWithObjects:@"Film 1",@"Film 2",@"Film 3",@"Film 4",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7", nil];
    self.itemsCollection2 = self.itemsCollection1;
    self.itemsCollection3 = self.itemsCollection1;
    self.itemsCollection4 = self.itemsCollection1;
    
    [self.collectionView1 registerNib:[BigBannerCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    CellConfigureBlock cellConfigureBanner = ^(BigBannerCell *cell, NSString *item){
        cell.label.text = item;
    };
    self.dataSourceCollection1 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection1 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureBanner];
    self.collectionView1.dataSource = self.dataSourceCollection1;
    self.collectionView1.collectionViewLayout = [[SideScrollBig alloc]init];

    
    [self.collectionView2 registerNib:[BigBannerCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.collectionView2.dataSource = self.dataSourceCollection1;
    self.collectionView2.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];

    
    [self.collectionView3 registerNib:[BigBannerCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.collectionView3.dataSource = self.dataSourceCollection1;
    self.collectionView3.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];

    
    [self.collectionView4 registerNib:[BigBannerCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.collectionView4.dataSource = self.dataSourceCollection1;
    self.collectionView4.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
