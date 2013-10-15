//
//  ContentOverviewViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/30/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ContentOverviewViewController.h"
#import "ArrayDataSource.h"
#import "ImageCell.h"
#import "MovieDAO.h"
#import "Movie.h"

static NSString * const cellIdentifierBanner = @"cellIdentifierBanner";
static NSString * const cellIdentifierRegular = @"cellIdentifierRegular";

@interface ContentOverviewViewController ()

@property (strong, nonatomic) ArrayDataSource *dataSourceCollection1;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection2;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection3;
@property (strong, nonatomic) ArrayDataSource *dataSourceCollection4;

@end

@implementation ContentOverviewViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.itemsCollection1 = [NSMutableArray arrayWithObjects:@"Film 1",@"Film 2",@"Film 3",@"Film 4",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7",@"Film 5",@"Film 6",@"Film 7", nil];
    self.itemsCollection2 = self.itemsCollection1;
    self.itemsCollection3 = self.itemsCollection1;
    self.itemsCollection4 = self.itemsCollection1;
    
    self.itemsCollection1 = [MovieDAO getHeadliningMovies];
    
    [self.collectionView1 registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    CellConfigureBlock cellConfigureBanner = ^(ImageCell *cell, Movie *movie){
        cell.imageView.image = [UIImage imageNamed:movie.imageName];
    };
    self.dataSourceCollection1 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection1 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureBanner];
    self.collectionView1.dataSource = self.dataSourceCollection1;
    self.collectionView1.decelerationRate = UIScrollViewDecelerationRateFast;

    [self.collectionView2 registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    CellConfigureBlock cellConfigureSmall = ^(ImageCell *cell, NSString *item){

    };
    self.dataSourceCollection2 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection2 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureSmall];
    self.collectionView2.dataSource = self.dataSourceCollection2;
    self.collectionView2.decelerationRate = UIScrollViewDecelerationRateFast;

    [self.collectionView3 registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.collectionView3.dataSource = self.dataSourceCollection2;
    self.collectionView3.decelerationRate = UIScrollViewDecelerationRateFast;

    [self.collectionView4 registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.collectionView4.dataSource = self.dataSourceCollection2;
    self.collectionView4.decelerationRate = UIScrollViewDecelerationRateFast;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
