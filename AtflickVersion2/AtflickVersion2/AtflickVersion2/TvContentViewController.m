//
//  TvContentViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "TvContentViewController.h"
#import "ContentOverviewViewController.h"
#import "ContentDisplayView.h"

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
    [self.currentDisplayViewController setWidth:self.view.frame.size.width];
    [self.contentPlaceholderScrollView addSubview:self.currentDisplayViewController.view];
    [self.view sendSubviewToBack:self.contentPlaceholderScrollView];
    [self.currentDisplayViewController didMoveToParentViewController:self];
    
    self.contentPlaceholderScrollView.contentSize = self.currentDisplayViewController.view.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeCurrentDisplayViewController
{
    [self.currentDisplayViewController removeFromParentViewController];
    [self.currentDisplayViewController.view removeFromSuperview];
    self.currentDisplayViewController = nil;
}






@end
