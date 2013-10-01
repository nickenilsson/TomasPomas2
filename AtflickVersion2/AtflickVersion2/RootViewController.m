//
//  RootViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "RootViewController.h"
#import "FilmContentViewController.h"
#import "TvContentViewController.h"

#define ANIMATION_DURATION 0.2
#define MAX_PAN_WIDTH 400

@interface RootViewController ()

@property (nonatomic, strong) MainMenuViewController *mainmenuViewController;
@property (nonatomic, strong) UIViewController *currentContentViewController;
@property (nonatomic) CGPoint centerOfScreen;
@property (nonatomic) BOOL menuIsActive;

@end

@implementation RootViewController

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
    self.centerOfScreen = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self addContentViewController:[[TvContentViewController alloc] init]];
    [self setFrameForContentViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonMenuPressed:(id)sender {
    if(self.menuIsActive){
        [self hideMenuWithAnimation];
    }else{
        [self showMenuWithAnimation];
    }
}

- (IBAction)buttonResizePressed:(id)sender {
}

- (IBAction)panGestureHappened:(id)sender {
    
    [self addMainMenu];
    CGPoint translation = [sender translationInView:self.view];
    
    CGPoint newCenter = CGPointMake(self.placeholderForViews.center.x + translation.x, self.placeholderForViews.center.y);
    if (newCenter.x > self.centerOfScreen.x + MAX_PAN_WIDTH) {
        newCenter.x = self.centerOfScreen.x + MAX_PAN_WIDTH;
    }else if (newCenter.x < self.centerOfScreen.x){
        newCenter.x = self.centerOfScreen.x;
    }
    self.placeholderForViews.center = newCenter;
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGFloat offset = self.placeholderForViews.center.x - self.centerOfScreen.x;
        if (offset > MAX_PAN_WIDTH / 2) {
            [self showMenuWithAnimation];
        }else{
            [self hideMenuWithAnimation];
        }
    }

    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (IBAction)swipeGestureRightHappened:(id)sender {
    [self showMenuWithAnimation];
}

- (IBAction)swipeGestureLeftHappened:(id)sender {
    [self hideMenuWithAnimation];
}
-(void) showMenuWithAnimation
{
    [self addMainMenu];
    CGPoint newCenter = CGPointMake(self.centerOfScreen.x + MAX_PAN_WIDTH, self.placeholderForViews.center.y);
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderForViews.center = newCenter;
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = YES;
        }
    }];
}
-(void) addMainMenu
{
    if(self.mainmenuViewController == nil){
        self.mainmenuViewController = [[MainMenuViewController alloc]init];
        [self addChildViewController:self.mainmenuViewController];
        [self.mainmenuViewController didMoveToParentViewController:self];
        [self.placeholderForMenu addSubview:self.mainmenuViewController.view];
    }
}
-(void) hideMenuWithAnimation
{
    [self addMainMenu];
    CGPoint newCenter = CGPointMake(self.centerOfScreen.x , self.placeholderForViews.center.y);
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderForViews.center = newCenter;
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = NO;
            [self removeMainMenu];
        }
    }];
}
-(void) removeMainMenu
{
    if (self.mainmenuViewController != nil) {
        [self.mainmenuViewController removeFromParentViewController];
        [self.mainmenuViewController.view removeFromSuperview];
        self.mainmenuViewController = nil;
    }
}
-(void) menuItemSelectedWithIndex:(NSUInteger)index
{
    UIViewController *viewControllerToAdd = [self getContentViewControllerCorrespondingToIndex:index];
    [self addContentViewController:viewControllerToAdd];
    [self setFrameForContentViewController];
    
}
-(void) addContentViewController:(UIViewController *) viewController
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.placeholderForViews addSubview:viewController.view];
    self.currentContentViewController = viewController;
}
-(void)setFrameForContentViewController
{
    [self.placeholderForViews setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.currentContentViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderForViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.currentContentViewController.view}]];
    [self.placeholderForViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topBar][contentView]|" options:0 metrics:nil views:@{@"topBar": self.topBar , @"contentView" : self.currentContentViewController.view}]];
}
-(UIViewController *) getContentViewControllerCorrespondingToIndex: (NSUInteger) index
{
    UIViewController *viewController;
    switch (index) {
        case 0:{
            viewController = [[TvContentViewController alloc]init];
            break;
        }
        default:{
            viewController = [[TvContentViewController alloc]init];
            break;
        }
    }
    return viewController;
}

@end
