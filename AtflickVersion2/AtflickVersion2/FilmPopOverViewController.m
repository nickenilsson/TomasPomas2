//
//  FilmPopOverViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FilmPopOverViewController.h"
#import "Movie.h"
#import "ArrayDataSource.h"
#import "ImageCell.h"
#import "MovieDAO.h"
#import "SideScrollLayoutSmall.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface FilmPopOverViewController ()

@property (strong, nonatomic) Movie *movie;

@property (strong, nonatomic) NSMutableArray *relatedMovies;
@property (strong, nonatomic) ArrayDataSource *collectionViewDatasource;
@property (strong, nonatomic) NSMutableArray *itemsCollectionView;

@end

@implementation FilmPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithMovieObject:(Movie *)movie
{
    self = [super init];
    if(self){
        self.movie = movie;
    }
    return self;
}
-(void) viewDidLayoutSubviews
{
    self.labelDescription.numberOfLines = 0;
    [self.labelDescription sizeToFit];
        
    [self.view layoutIfNeeded];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.view.layer.borderWidth = 1;
    /*
     self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
     self.view.layer.shadowOffset = CGSizeMake(2, 2);
     self.view.layer.shadowRadius = 3;
     self.view.layer.shadowOpacity = 1;
     self.view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.view.bounds] CGPath];
     self.view.layer.shouldRasterize = YES;
     */


    
    self.imageView.image = [UIImage imageNamed:self.movie.imageName];
    self.smallLabel.text = self.movie.title;
    self.labelDescription.text = self.movie.description;
    
    self.itemsCollectionView = [MovieDAO getRelatedMovies:self.movie];
    [self.collectionView registerNib:[ImageCell nib] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.delegate = (id) self;
    
    CellConfigureBlock cellConfiguration = ^(ImageCell *cell, Movie *movie){
        cell.imageView.image = [UIImage imageNamed:movie.imageName];
    };
    
    self.collectionViewDatasource = [[ArrayDataSource alloc]initWithItems:self.itemsCollectionView cellIdentifier:cellIdentifier configureCellBlock:cellConfiguration];
    self.collectionView.dataSource = self.collectionViewDatasource;
    self.collectionView.collectionViewLayout = [[SideScrollLayoutSmall alloc] init];
    [self.view bringSubviewToFront:self.collectionView];
    
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.itemsCollectionView objectAtIndex:indexPath.item];
    FilmPopOverViewController *popOver = [[FilmPopOverViewController alloc] initWithMovieObject: movie];
    [self.delegate presentPopOver:popOver];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
