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
@property (strong, nonatomic) NSArray *dropDownTitles;

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
    
    self.dropDownTitles = [NSArray arrayWithObjects:@"Featured", @"Overview",@"New Movies",@"Popular",@"Recommended",  nil];
    NSMutableArray *options = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < self.dropDownTitles.count; i++) {
        [options addObject:[NSNumber numberWithInt:i+1]];
    }

    [self.dropDownMenu setTitle:@"Overview"];
    [self.dropDownMenu setSelectionOptions:options withTitles:self.dropDownTitles];
    self.dropDownMenu.delegate = (id) self;
    
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
-(void) setContainerScrollEnabled:(BOOL) value
{
    self.contentPlaceholderScrollView.scrollEnabled = value;
}

- (void)dropDownControlView:(DropDownMenu *)view didFinishWithSelection:(id)selection
{
    if(selection != nil){
        [self.dropDownMenu setTitle:[self.dropDownTitles objectAtIndex:[selection integerValue]-1]];
    }
}
//Superview is changing it's frame
-(void) superViewChangingToFrame:(CGRect)frame
{
    self.currentDisplayViewController.view.frame = CGRectMake(self.currentDisplayViewController.view.frame.origin.x, self.currentDisplayViewController.view.frame.origin.y, frame.size.width, self.currentDisplayViewController.view.frame.size.height);

}





@end
