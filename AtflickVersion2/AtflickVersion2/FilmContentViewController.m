//
//  FilmContentViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FilmContentViewController.h"
#import "ContentOverviewViewController.h"
#import "SmartCollectionViewController.h"
#import "ContentDisplayView.h"
#import "FilmPopOverViewController.h"
#import "Movie.h"
#import "OverviewController2.h"
#import "Colors.h"



@interface FilmContentViewController ()

@property (strong, nonatomic) ContentDisplayView *contentViewController;
@property (strong, nonatomic) NSMutableArray *dropDownMenuOptions;
@property (strong, nonatomic) NSArray *dropDownMenuTitles;
@property (strong, nonatomic) NSLayoutConstraint *contentWidthConstraint;

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
-(void) viewWillLayoutSubviews
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentOptionsBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addContentDisplayView:[[OverviewController2 alloc] init]];

    [self setConstraintsForContentDisplayView];
    self.contentOptionsBar.backgroundColor = COLOR_CONTENT_OPTIONS_BAR;
    [self setupDropDownMenu];
    [self.dropDownMenu setTitle:[self.dropDownMenuTitles objectAtIndex:0]];

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
    [self.view bringSubviewToFront:self.dropDownMenu];
    [self.view sendSubviewToBack:self.contentViewController.view];
}
-(void) setupDropDownMenu
{
    self.dropDownMenu.delegate = (id) self;
    self.dropDownMenuTitles = [NSArray arrayWithObjects:@"Overview",@"Featured",@"Recommended",@"Popular", nil];
    self.dropDownMenuOptions = [NSMutableArray arrayWithCapacity:self.dropDownMenuTitles.count];
    for (int i = 0; i < self.dropDownMenuTitles.count; i++) {
        [self.dropDownMenuOptions addObject:[NSNumber numberWithInt:i]];
    }
    [self.dropDownMenu setSelectionOptions:self.dropDownMenuOptions withTitles:self.dropDownMenuTitles];
}
- (void)dropDownControlView:(DropDownMenu *)view didFinishWithSelection:(id)selection
{
    int index = [selection integerValue];
    switch (index) {
        case 0:{
            [self.dropDownMenu setTitle:[self.dropDownMenuTitles objectAtIndex:index]];
            [self removeCurrentContentDisplayView];
            [self addContentDisplayView:[[OverviewController2 alloc]init]];
            [self setConstraintsForContentDisplayView];
             
            break;
        }
        default:{
        
            [self.dropDownMenu setTitle:[self.dropDownMenuTitles objectAtIndex:index]];
            [self removeCurrentContentDisplayView];
            [self addContentDisplayView:[[SmartCollectionViewController alloc]init]];
            [self setConstraintsForContentDisplayView];

            break;        
        }
    }
}
-(void) objectSelectedInDisplayView:(id)object
{
    Movie *movie = (Movie *)object;
    FilmPopOverViewController *popOver = [[FilmPopOverViewController alloc]initWithMovieObject:movie];
    [self.delegate presentPopOverViewController:popOver];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
