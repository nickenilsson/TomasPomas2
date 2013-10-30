//
//  FilmContentViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FilmContentViewController.h"
#import "SmartCollectionViewController.h"
#import "ContentDisplayView.h"
#import "FilmInfoViewController.h"
#import "Movie.h"
#import "OverviewController2.h"
#import "Colors.h"
#import "MovieDAO.h"
#import "PopOverContentViewController.h"

@interface FilmContentViewController ()

@property (strong, nonatomic) ContentDisplayView *contentViewController;
@property (strong, nonatomic) NSLayoutConstraint *contentWidthConstraint;
@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) UIPopoverController *popOverController;
@property (strong, nonatomic) NSMutableArray *popOverTitles;
@property (strong, nonatomic) NSMutableArray *popOverOptions;

@end

@implementation FilmContentViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self initialViewSetup];
    [self requestDataToDisplay];
    [self createDataForPopOver];
    [self addContentDisplayView:[[OverviewController2 alloc] init]];

    [self setConstraintsForContentDisplayView];
    self.contentOptionsBar.backgroundColor = COLOR_CONTENT_OPTIONS_BAR;
   
}
-(void) initialViewSetup
{
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentOptionsBar setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void) requestDataToDisplay
{
    // request data from future movieHtthpClient
    self.movies = [MovieDAO getMoviesTest];
}
-(void) createDataForPopOver
{
    self.popOverTitles = [NSMutableArray arrayWithObjects:@"Overview",@"Featured",@"Recommended",@"New on Atflick", nil];
    
    self.popOverOptions = [NSMutableArray arrayWithCapacity:self.popOverTitles.count];
    for (int i = 0; i < self.popOverTitles.count; i++) {
        [self.popOverOptions addObject:[NSNumber numberWithInt:i]];
    }
}
-(void) addContentDisplayView:(ContentDisplayView *) displayView
{
    [self addChildViewController:displayView];
    [displayView didMoveToParentViewController:self];
    [self.view addSubview:displayView.view];
    displayView.delegate = (id) self;
    self.contentViewController = displayView;
    
}
-(void) removeCurrentContentDisplayView
{
    [self.contentViewController removeFromParentViewController];
    [self.contentViewController.view removeFromSuperview];
    self.contentViewController = nil;
    
}
-(void) setConstraintsForContentDisplayView
{
    [self.contentViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:nil views:@{@"content": self.contentViewController.view}]];;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[optionsBar][content]|" options:0 metrics:nil views:@{@"optionsBar": self.contentOptionsBar, @"content" : self.contentViewController.view}]];
    [self.view sendSubviewToBack:self.contentViewController.view];
}

-(void) objectSelectedInDisplayView:(id)object
{
    Movie *movie = (Movie *)object;
    FilmInfoViewController *popOver = [[FilmInfoViewController alloc]initWithMovieObject:movie];
    [self.delegate presentPopOverViewController:popOver];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PopOverMenuButtonTapped:(UIButton *)sender {
    
    PopOverContentViewController *popOverContent = [[PopOverContentViewController alloc]initWithMenuTitles:self.popOverTitles menuOptions:self.popOverOptions];
    popOverContent.delegate = (id) self;
    
     self.popOverController = [[UIPopoverController alloc] initWithContentViewController:popOverContent];
    self.popOverController.backgroundColor = COLOR_BACKGROUND_POPOVER;
    [self.popOverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}
-(void)popOverMenuItemSelected:(NSNumber *)selection
{
    [self.popOverButton setTitle:[self.popOverTitles objectAtIndex:selection.integerValue] forState:UIControlStateNormal];
    [self.popOverController dismissPopoverAnimated:YES];
    
    switch (selection.integerValue) {
        case 0:
            [self removeCurrentContentDisplayView];
            [self addContentDisplayView:[[OverviewController2 alloc]init]];
            [self setConstraintsForContentDisplayView];
            break;
        case 1:
            [self removeCurrentContentDisplayView];
            [self addContentDisplayView:[[SmartCollectionViewController alloc]initWithItems:self.movies]];
            [self setConstraintsForContentDisplayView];
            break;
            
        default:
            break;
    }
}
@end
