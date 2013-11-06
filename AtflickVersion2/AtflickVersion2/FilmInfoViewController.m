//
//  FilmPopOverViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FilmInfoViewController.h"
#import "Movie.h"
#import "ArrayDataSource.h"
#import "MovieDAO.h"
#import "SideScrollLayoutSmall.h"
#import "GridCell.h"
#import "NotificationNames.h"
#import "AddToOrSharePopOverViewController.h"
#import "Colors.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface FilmInfoViewController ()

@property (strong, nonatomic) Movie *movie;

@property (strong, nonatomic) NSMutableArray *relatedMovies;
@property (strong, nonatomic) ArrayDataSource *collectionViewDatasource;
@property (strong, nonatomic) NSMutableArray *itemsCollectionView;
@property (strong, nonatomic) UIPopoverController *popOverController;

@end

@implementation FilmInfoViewController

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

- (IBAction)addToButtonTapped:(UIButton *)sender {
    AddToOrSharePopOverViewController *popOverContent = [[AddToOrSharePopOverViewController alloc]initWithMediaObject:self.movie];
    self.popOverController = [[UIPopoverController alloc]initWithContentViewController:popOverContent];
    popOverContent.parentPopOverController = self.popOverController;

    [self.popOverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)trailerButtontapped:(id)sender {

    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.movie forKey:NOTIFICATION_OBJECT];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:PLAY_MEDIA_OBJECT object:self userInfo:userInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.view.layer.borderWidth = 1;
    
    self.smallLabel.text = self.movie.title;

    self.imageView.image = [UIImage imageNamed:self.movie.imageName];
    self.textViewDescription.text = self.movie.description;
    
    self.itemsCollectionView = [MovieDAO getRelatedMovies:self.movie];
    [self.collectionView registerNib:[GridCell nib] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.delegate = (id) self;
    
    CellConfigureBlock cellConfiguration = ^(GridCell *cell, Movie *movie){
        cell.imageView.image = [UIImage imageNamed:movie.imageNameSmall];
    };
    
    self.collectionViewDatasource = [[ArrayDataSource alloc]initWithItems:self.itemsCollectionView cellIdentifier:cellIdentifier configureCellBlock:cellConfiguration];
    self.collectionView.dataSource = self.collectionViewDatasource;
    self.collectionView.collectionViewLayout = [[SideScrollLayoutSmall alloc] init];
    [self.view bringSubviewToFront:self.collectionView];
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.itemsCollectionView objectAtIndex:indexPath.item];
    FilmInfoViewController *infoView = [[FilmInfoViewController alloc] initWithMovieObject: movie];
    [self.delegate newInfoViewRequestedFromInfoView:(UIViewController *) infoView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
