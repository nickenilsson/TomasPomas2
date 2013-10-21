//
//  RootViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "FilmContentViewController.h"
#import "TvContentViewController.h"
#import "ViewControllerHandler.h"
#import "PopOverController.h"
#import "Colors.h"
#import "InfoViewController.h"
#import "InfoViewAnimationController.h"


#define ANIMATION_DURATION 0.2
#define SHADOW_FADE_IN_TIME 0.1
#define DURATION_POP_OVER_SLIDE 1
#define DURATION_POP_OVER_FADE_OUT 0.1

@interface RootViewController ()

@property (strong, nonatomic) MainMenuViewController *mainmenuViewController;
@property (strong, nonatomic) ContentViewController *currentContentViewController;
@property (strong, nonatomic) ViewControllerHandler *viewControllerHandler;
@property (strong, nonatomic) InfoViewAnimationController *popOverController;
@property (strong, nonatomic) UIView *shadowView;
@property (nonatomic) CGPoint centerOfScreen;
@property (nonatomic) BOOL menuIsActive;
@property (strong, nonatomic) UIView *popOverPlaceholder;
@property (nonatomic) CGFloat maxPanWidth;
@property (nonatomic) CGFloat maxPanWidthMenu;
@property (nonatomic) BOOL contentWindowIsSmall;
@property (nonatomic) CGFloat shrinkingDistance;
@property (strong, nonatomic) NSLayoutConstraint *contentTrailingConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuLeadingConstraint;



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
    self.maxPanWidthMenu = -self.maxPanWidth / 8;
    [self.mainPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.viewControllerHandler = [[ViewControllerHandler alloc]init];
    
    self.centerOfScreen = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self menuItemSelectedWithIndex:1];

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
    
    CGFloat newConstantMainPlaceholder = self.placeholderLeadingConstraint.constant + translation.x;
    CGFloat translationXforMenu = translation.x / 8;
    CGFloat newConstantForMenu = self.menuLeadingConstraint.constant + translationXforMenu;
    
    if (newConstantMainPlaceholder > self.maxPanWidth) {
        newConstantMainPlaceholder = self.maxPanWidth;
        newConstantForMenu = 0;
    }else if (newConstantMainPlaceholder < 0){
        newConstantMainPlaceholder = 0;
        newConstantForMenu = self.maxPanWidthMenu;
    }
    self.placeholderLeadingConstraint.constant = newConstantMainPlaceholder;
    self.menuLeadingConstraint.constant = newConstantForMenu;
    
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
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = self.maxPanWidth;
        self.menuLeadingConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = YES;
        }
    }];
}
-(void) hideMenuWithAnimation
{
    [self addMainMenu];
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = 0;
        self.menuLeadingConstraint.constant = self.maxPanWidthMenu;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = NO;
            [self removeMainMenu];
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
        [self setConstraintsForMainMenu];
    }
}
-(void) setConstraintsForMainMenu
{
    [self.placeholderForMenu setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainmenuViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderForMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menu]|" options:0 metrics:nil views:@{@"menu": self.mainmenuViewController.view}]];
    
    self.menuLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.mainmenuViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.placeholderForMenu attribute:NSLayoutAttributeLeft multiplier:1 constant:self.maxPanWidthMenu];
    [self.placeholderForMenu addConstraint:self.menuLeadingConstraint];
    
    [self.placeholderForMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.mainmenuViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.placeholderForMenu attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view layoutIfNeeded];
    
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
    [self.mainPlaceholder addSubview:viewController.view];
    viewController.delegate = (id) self;
    self.currentContentViewController = viewController;
    [self.mainPlaceholder bringSubviewToFront:self.topBar];
}

-(void)setFrameForContentViewController
{
    [self.currentContentViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.contentTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.currentContentViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainPlaceholder attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.mainPlaceholder addConstraint:self.contentTrailingConstraint];
    [self.mainPlaceholder addConstraint:[NSLayoutConstraint constraintWithItem:self.currentContentViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainPlaceholder attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    
    [self.mainPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topBar][contentView]|" options:0 metrics:nil views:@{@"topBar": self.topBar , @"contentView" : self.currentContentViewController.view}]];
    [self.view layoutIfNeeded];
}
// ContentViewControllerDelegate - called from current content view controller
-(void) presentPopOverViewController:(InfoViewController *) viewController
{
    [self addShadowView];
    [self addPopOverController];
    [self setConstraintsForPopOverController];
    [self.popOverController presentNewInfoView:viewController];
}
-(void) addPopOverController
{
    self.popOverController = [[InfoViewAnimationController alloc]init];
    [self.currentContentViewController addChildViewController:self.popOverController];
    [self.popOverController didMoveToParentViewController:self.currentContentViewController];
    self.popOverController.delegate = (id) self;
    [self.currentContentViewController.view addSubview:self.popOverController.view];
    [self.currentContentViewController.view insertSubview:self.shadowView belowSubview:self.popOverController.view];
}
-(void) setConstraintsForPopOverController
{
    [self.popOverController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.currentContentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[popOverController]|" options:0 metrics:nil views:@{@"popOverController": self.popOverController.view}]];
    [self.currentContentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[popOverController]|" options:0 metrics:nil views:@{@"popOverController": self.popOverController.view}]];
}
-(void) addShadowView
{
    self.shadowView = [[UIView alloc] init];
    [self.mainPlaceholder addSubview:self.shadowView];
    [self.shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    [self.mainPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0;
    
    [UIView animateWithDuration:SHADOW_FADE_IN_TIME delay:0 options:SHADOW_FADE_IN_TIME animations:^{
        self.shadowView.alpha = 0.7;
    } completion:^(BOOL finished){} ];
}
-(void) removeInfoViewAnimationController
{
    [UIView animateWithDuration:DURATION_POP_OVER_FADE_OUT delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.popOverController.view.alpha = 0;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished) {
            [self.popOverController removeFromParentViewController];
            [self.popOverController.view removeFromSuperview];
            self.popOverController = nil;
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
        }
        
    }];
    
}

@end
