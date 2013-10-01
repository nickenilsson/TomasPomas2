//
//  TvContentViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "TvContentViewController.h"
#import "ContentOverviewViewController.h"
#import "ListViewController.h"
#import "ContentDisplayView.h"
#import "ContentDisplayGrid.h"

@interface TvContentViewController ()

@property (strong, nonatomic) ContentDisplayView *currentDisplayViewController;

@end

@implementation TvContentViewController

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
    
    self.currentDisplayViewController = [[ContentOverviewViewController alloc]init];
    [self addChildViewController:self.currentDisplayViewController];
    [self.contentPlaceholderScrollView addSubview:self.currentDisplayViewController.view];
    [self.currentDisplayViewController didMoveToParentViewController:self];
    self.contentPlaceholderScrollView.contentSize = self.currentDisplayViewController.view.bounds.size;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showContentGridStyle:(id)sender {
    [self removeCurrentDisplayViewController];
    self.currentDisplayViewController = [[ContentDisplayGrid alloc] init];
    self.currentDisplayViewController.items = [NSMutableArray arrayWithObjects:@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1", nil];
    [self addChildViewController:self.currentDisplayViewController];
    [self.currentDisplayViewController didMoveToParentViewController:self];
    [self.contentPlaceholderScrollView addSubview:self.currentDisplayViewController.view];
    self.contentPlaceholderScrollView.contentSize = self.currentDisplayViewController.view.bounds.size;
    
}

- (IBAction)showContentOverviewStyle:(id)sender {
    [self removeCurrentDisplayViewController];
    
    
}

- (IBAction)showContentListStyle:(id)sender {
    [self removeCurrentDisplayViewController];
    self.currentDisplayViewController = [[ListViewController alloc] init];
    self.currentDisplayViewController.items = [NSMutableArray arrayWithObjects:@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1",@"item 1", nil];
    [self addChildViewController:self.currentDisplayViewController];
    self.currentDisplayViewController.delegate = (id) self;
    [self.currentDisplayViewController didMoveToParentViewController:self];
    [self.contentPlaceholderScrollView addSubview:self.currentDisplayViewController.view];
    self.contentPlaceholderScrollView.contentSize = self.currentDisplayViewController.view.bounds.size;

    
}

- (IBAction)loadSomething:(id)sender {
    
    
}
-(void) removeCurrentDisplayViewController
{
    [self.currentDisplayViewController removeFromParentViewController];
    [self.currentDisplayViewController.view removeFromSuperview];
    self.currentDisplayViewController = nil;
}
-(void) setContainerScrollEnabled:(BOOL) value
{
    self.contentPlaceholderScrollView.scrollEnabled = value;
    NSLog(@"scrollEnabled = %i", self.contentPlaceholderScrollView.scrollEnabled);
}

@end
