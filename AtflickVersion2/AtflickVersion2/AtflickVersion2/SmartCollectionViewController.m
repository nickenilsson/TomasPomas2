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
#import "Movie.h"

static NSString* const cellIdentifierList = @"cellIdentifierList";
static NSString* const cellIdentifierGrid = @"cellIdentifierGrid";


@interface SmartCollectionViewController ()

@property (nonatomic) BOOL inListMode;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UINib *cellNib;

@end

@implementation SmartCollectionViewController

-(id) initWithItems:(NSMutableArray *) items
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

    [self.collectionView registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifierGrid];
    [self.collectionView registerNib:[ListCell nib] forCellWithReuseIdentifier:cellIdentifierList];
    
    self.collectionView.delegate = (id) self;
    self.collectionView.dataSource = (id)self;
    self.collectionView.collectionViewLayout = [[GridFlowLayout alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonListTapped:(id)sender {
    if(!self.inListMode){
        [self.collectionView setCollectionViewLayout:[[ListFlowLayout alloc]init] animated:NO];
        [self.collectionView.collectionViewLayout invalidateLayout];
        
        [self.collectionView reloadData];
        self.inListMode = YES;
    }
}

- (IBAction)buttonGridTapped:(id)sender {
    if(self.inListMode){
        [self.collectionView setCollectionViewLayout:[[GridFlowLayout alloc]init] animated:NO];
        [self.collectionView.collectionViewLayout invalidateLayout];

        [self.collectionView reloadData];
        self.inListMode = NO;

    }
}
// Collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.items objectAtIndex:indexPath.item];
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[ListFlowLayout class]]) {
        ListCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierList forIndexPath:indexPath];
        cell.bigLabel.text = movie.title;
        cell.imageView.image = [UIImage imageNamed:movie.imageNameSmall];
        return cell;
    }else{
        GridCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierGrid forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:movie.imageNameSmall];
        return cell;
    }
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate objectSelectedInDisplayView:[self.items objectAtIndex:indexPath.item]];
}
@end
