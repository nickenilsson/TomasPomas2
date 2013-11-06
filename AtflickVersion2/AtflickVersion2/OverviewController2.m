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
#import "SideScrollLayoutSmall.h"
#import "SideScrollBig.h"
#import "Movie.h"
#import "MovieDAO.h"
#import "GridCell.h"

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
    
    self.itemsCollection1 = [MovieDAO getHeadliningMovies];
    [self manipulateArrayForInfiniteScrolling];
    
    [self.collectionView1 registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    CellConfigureBlock cellConfigureBanner = ^(GridCell *cell, Movie *movie){
       
        cell.imageView.image = [UIImage imageNamed:movie.imageName];
    
    };
    
    self.dataSourceCollection1 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection1 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureBanner];
    self.collectionView1.dataSource = self.dataSourceCollection1;
    self.collectionView1.delegate = (id) self;
    self.collectionView1.pagingEnabled = YES;
    self.collectionView1.collectionViewLayout = [[SideScrollBig alloc]init];
    self.collectionView1.bounces = NO;
    
    NSIndexPath *indexPathStart = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.collectionView1 scrollToItemAtIndexPath:indexPathStart atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    
    CellConfigureBlock cellConfigureSmall = ^(GridCell *cell, Movie *movie){
        cell.imageView.image = [UIImage imageNamed:movie.imageNameSmall];
        cell.layer.borderColor = [[UIColor grayColor]CGColor ];
        cell.layer.borderWidth = 1;
        
    };
    
    self.itemsCollection2 = [MovieDAO getMoviesTest];
    [self.collectionView2 registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.dataSourceCollection2 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection2 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureSmall];
    self.collectionView2.dataSource = self.dataSourceCollection2;
    self.collectionView2.delegate = (id) self;
    self.collectionView2.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];
    
    self.itemsCollection3 = [MovieDAO getMoviesTest];
    NSLog(@"getmovies.count %i", self.itemsCollection3.count);
    [self.collectionView3 registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.dataSourceCollection3 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection3 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureSmall];
    self.collectionView3.dataSource = self.dataSourceCollection3;
    self.collectionView3.delegate = (id) self;
    self.collectionView3.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];
    
    self.itemsCollection4 = [MovieDAO getMoviesTest];
    [self.collectionView4 registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifierBanner];
    self.dataSourceCollection4 = [[ArrayDataSource alloc] initWithItems:self.itemsCollection4 cellIdentifier:cellIdentifierBanner configureCellBlock:cellConfigureSmall];
    self.collectionView4.dataSource = self.dataSourceCollection4;
    self.collectionView4.delegate = (id) self;
    self.collectionView4.collectionViewLayout = [[SideScrollLayoutSmall alloc]init];
    
    
}

-(void) manipulateArrayForInfiniteScrolling
{
    // Grab references to the first and last items
    // They're typed as id so you don't need to worry about what kind
    // of objects the originalArray is holding
    id firstItem = self.itemsCollection1[0];
    id lastItem = [self.itemsCollection1 lastObject];
    
    NSMutableArray *workingArray = [self.itemsCollection1 mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    self.itemsCollection1 = [NSMutableArray arrayWithArray:workingArray];

}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        [self.delegate objectSelectedInDisplayView:[self.itemsCollection1 objectAtIndex:indexPath.item]];
    }else if (collectionView.tag == 1){
        [self.delegate objectSelectedInDisplayView:[self.itemsCollection2 objectAtIndex:indexPath.item]];

    }else if (collectionView.tag == 2){
        [self.delegate objectSelectedInDisplayView:[self.itemsCollection3 objectAtIndex:indexPath.item]];

    }else if (collectionView.tag == 3){
        [self.delegate objectSelectedInDisplayView:[self.itemsCollection4 objectAtIndex:indexPath.item]];

    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView1) {
        float contentOffsetWhenFullyScrolledRight = self.collectionView1.bounds.size.width * ([self.itemsCollection1 count] -1);
        
        if (scrollView.contentOffset.x > contentOffsetWhenFullyScrolledRight - 300) {
            float newHorizontalOffset = scrollView.contentOffset.x - self.collectionView1.frame.size.width * (self.itemsCollection1.count - 2);
            [scrollView setContentOffset:CGPointMake(newHorizontalOffset, scrollView.contentOffset.y)];
            
        } else if (scrollView.contentOffset.x < 300 )  {
            float newHorizontalOffset = scrollView.contentOffset.x + self.collectionView1.bounds.size.width * (self.itemsCollection1.count-2);
            [scrollView setContentOffset:CGPointMake(newHorizontalOffset, scrollView.contentOffset.y)];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
