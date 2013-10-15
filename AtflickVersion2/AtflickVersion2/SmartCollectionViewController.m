//
//  SmartCollectionViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/3/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SmartCollectionViewController.h"
#import "ImageCell.h"
#import "ArrayDataSource.h"
#import "ListFlowLayout.h"
#import "GridFlowLayout.h"
#import "GridCell.h"
#import "ListCell.h"

static NSString* const cellIdentifier = @"cellIdentifier";

@interface SmartCollectionViewController ()

@property (nonatomic) BOOL inListMode;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) ArrayDataSource *datasource;
@property (strong, nonatomic) UINib *cellNib;

@end

@implementation SmartCollectionViewController

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

}

-(id) initWithItems:(NSArray *) items 
{
    self = [super init];
    if(self){
        self.items = [NSMutableArray arrayWithArray:items];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.inListMode = NO;

    self.items = [NSMutableArray arrayWithObjects:@"item 1",@"Item 3",@"Item 4",@"Item 5",@"Item 6",@"Item 7",@"Item 8",@"Item 9",@"Item 10",@"Item 11",@"Item 12",@"Item 13",@"Item 14",@"Item 15",@"Item 16",@"Item 17",@"Item 18",@"Item 19",@"Item 20", nil];
    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifier];
    
    CellConfigureBlock cellConfiguration = ^(ImageCell *cell, NSString *item){
        if ([self.collectionView.collectionViewLayout isKindOfClass:[ListFlowLayout class]]) {
            
        }
        //cell.label.text = item;
        /*
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        cell.layer.shadowRadius = 1.4;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOpacity = 1;
        [cell.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
        cell.layer.shouldRasterize = YES;
         */
    };
    self.datasource = [[ArrayDataSource alloc] initWithItems:self.items cellIdentifier:cellIdentifier configureCellBlock:cellConfiguration];
    self.collectionView.dataSource = self.datasource;
    self.collectionView.delegate = (id) self;
    self.collectionView.collectionViewLayout = [[GridFlowLayout alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonListTapped:(id)sender {
    if(!self.inListMode){
        [self.collectionView setCollectionViewLayout:[[ListFlowLayout alloc]init] animated:YES];
        [self.collectionView.collectionViewLayout invalidateLayout];

        self.inListMode = YES;
    }
}

- (IBAction)buttonGridTapped:(id)sender {
    if(self.inListMode){
        [self.collectionView setCollectionViewLayout:[[GridFlowLayout alloc]init] animated:YES];
        [self.collectionView.collectionViewLayout invalidateLayout];

        self.inListMode = NO;

    }
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate objectSelectedInDisplayView:[self.items objectAtIndex:indexPath.item]];
}
@end
