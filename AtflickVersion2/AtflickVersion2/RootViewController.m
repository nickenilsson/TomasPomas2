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
#import "ViewControllerHandler.h"

#define ANIMATION_DURATION 0.2
#define SHADOW_FADE_IN_TIME 0.1
#define DURATION_POP_OVER_SLIDE 1

@interface RootViewController ()

@property (strong, nonatomic) MainMenuViewController *mainmenuViewController;
@property (strong, nonatomic) ContentViewController *currentContentViewController;
@property (strong, nonatomic) ViewControllerHandler *viewControllerHandler;
@property (strong, nonatomic) UIView *shadowView;
@property (nonatomic) CGPoint centerOfScreen;
@property (nonatomic) BOOL menuIsActive;
@property (strong, nonatomic) NSMutableArray *popOverViewControllers;
@property (strong, nonatomic) UIView *popOverPlaceholder;
@property (nonatomic) CGFloat maxPanWidth;
@property (nonatomic) BOOL contentWindowIsSmall;
@property (nonatomic) CGFloat shrinkingDistance;
@property (strong, nonatomic) NSLayoutConstraint *contentTrailingConstraint;



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
    self.contentWindowIsSmall = NO;
    self.shrinkingDistance = -self.view.frame.size.width/3;
    self.maxPanWidth = self.view.bounds.size.width/3;
    [self.placeholderForViews setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.viewControllerHandler = [[ViewControllerHandler alloc]init];
    
    self.centerOfScreen = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self menuItemSelectedWithIndex:0];

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
    
    CGFloat newConstant;
    if (self.contentWindowIsSmall) {
        newConstant = 0;
    }else{
        newConstant = self.shrinkingDistance;
    }
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentTrailingConstraint.constant = newConstant;
        [self.view layoutIfNeeded];
        self.contentWindowIsSmall = !self.contentWindowIsSmall;
    } completion:^(BOOL finished){
    
    }];
    
}

- (IBAction)panGestureHappened:(id)sender
{
    CGPoint translation = [sender translationInView:self.view];
    
    [self addMainMenu];
    
    CGFloat newConstant = self.placeholderLeadingConstraint.constant + translation.x;
    if (newConstant > self.maxPanWidth) {
        newConstant = self.maxPanWidth;
    }else if (newConstant < 0){
        newConstant = 0;
    }
    self.placeholderLeadingConstraint.constant = newConstant;
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (self.placeholderLeadingConstraint.constant > (self.maxPanWidth / 2)) {
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
    CGFloat newConstant = self.maxPanWidth;
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = newConstant;
        [self.view layoutIfNeeded];
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
        self.mainmenuViewController.delegate = (id) self;
    }
}
-(void) hideMenuWithAnimation
{
    [self addMainMenu];
    CGFloat newConstant = 0;
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = newConstant;
        [self.view layoutIfNeeded];

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
    [self removeCurrentContentViewController];
    ContentViewController *viewControllerToAdd = [self.viewControllerHandler contentViewControllerCorrespondingToIndex:index];
    [self addContentViewController:viewControllerToAdd];
    [self setFrameForContentViewController];
    [self hideMenuWithAnimation];
    
}
-(void) removeCurrentContentViewController
{
    if(self.currentContentViewController != nil){
        [self.currentContentViewController removeFromParentViewController];
        [self.currentContentViewController.view removeFromSuperview];
        self.currentContentViewController = nil;
    }
}
-(void) addContentViewController:(ContentViewController *) viewController
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.placeholderForViews addSubview:viewController.view];
    viewController.delegate = (id) self;
    self.currentContentViewController = viewController;
}

-(void)setFrameForContentViewController
{
    [self.currentContentViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.contentTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.currentContentViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.placeholderForViews attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.placeholderForViews addConstraint:self.contentTrailingConstraint];
    
    [self.placeholderForViews addConstraint:[NSLayoutConstraint constraintWithItem:self.currentContentViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.placeholderForViews attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    
    [self.placeholderForViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topBar][contentView]|" options:0 metrics:nil views:@{@"topBar": self.topBar , @"contentView" : self.currentContentViewController.view}]];
    [self.view layoutIfNeeded];
}
// ContentViewControllerDelegate - called from current content view controller
-(void) presentPopOverViewController:(UIViewController *) viewController
{
    [self addShadowView];
}
-(void) addShadowView
{
    self.shadowView = [[UIView alloc] init];
    [self.placeholderForViews addSubview:self.shadowView];
    [self.shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderForViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    [self.placeholderForViews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0;
    
    [UIView animateWithDuration:SHADOW_FADE_IN_TIME delay:0 options:SHADOW_FADE_IN_TIME animations:^{
        self.shadowView.alpha = 0.6;
    } completion:^(BOOL finished){} ];
}


@end
