//
//  InfoViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/16/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "InfoViewAnimationController.h"
#import "FilmInfoViewController.h"

#define MAX_NUMBER_OF_INFOVIEWS 10
#define DURATION_SLIDE 0.2
#define PADDING 20
#define SIZE_CONSTANT 0.8

@interface InfoViewAnimationController ()

@property (nonatomic) CGSize storedWindowSize;
@property (strong, nonatomic) NSMutableArray *infoViews;
@property (strong, nonatomic) NSMutableArray *horizontalConstraints;
@property (nonatomic) CGFloat XPositionRightOfScreen;
@property (nonatomic) CGFloat XPositionInCenter;
@property (nonatomic) CGFloat XPositionLeftOfScreen;
@property (nonatomic) CGFloat XPositionFarOffLeft;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (strong, nonatomic) UIViewController *currentViewInCenter;
@property (strong, nonatomic) UIViewController *currentViewToTheLeft;

@property (strong, nonatomic) InfoViewController *oldInfoView;
@property (strong, nonatomic) NSLayoutConstraint *oldInfoViewConstraint;

@end

@implementation InfoViewAnimationController

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
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.view.backgroundColor = [UIColor clearColor];
    self.infoViews = [NSMutableArray arrayWithCapacity:MAX_NUMBER_OF_INFOVIEWS];
    self.horizontalConstraints = [NSMutableArray arrayWithCapacity:MAX_NUMBER_OF_INFOVIEWS];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHappened:)];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    self.tapGestureRecognizer.delegate = (id)self;

    
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self      action: @selector(rightSwipeHappened:)];
    [self.swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    self.swipeGestureRecognizer.delegate = (id) self;
    

    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews
{
    if ([self windowHasChangedSize:self.view.frame.size]) {
        [self updateSavedPositions];
        [self updatePositionsForActiveInfoViews];
    }
    [super viewDidLayoutSubviews];
}
-(BOOL) windowHasChangedSize:(CGSize) currentWindowSize
{
    if (self.storedWindowSize.width != currentWindowSize.width) {
        self.storedWindowSize = currentWindowSize;
        return YES;
    }
    return NO;
}
-(void) updateSavedPositions
{
    self.XPositionRightOfScreen = self.view.frame.size.width*SIZE_CONSTANT + 2*PADDING;
    self.XPositionInCenter = PADDING;
    self.XPositionLeftOfScreen = -self.view.frame.size.width*SIZE_CONSTANT;
    self.XPositionFarOffLeft = -self.view.frame.size.width*2*SIZE_CONSTANT - PADDING;
}
-(void) updatePositionsForActiveInfoViews
{
    if(self.horizontalConstraints.count > 1){
        NSLayoutConstraint *constraintInfoViewLeftOfScreen = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:1];
        constraintInfoViewLeftOfScreen.constant = self.XPositionLeftOfScreen;
        [self.view layoutIfNeeded];
    }
}
-(void) presentNewInfoView:(InfoViewController *) infoViewController
{
    [self addInfoView:infoViewController];
    [self.infoViews addObject:infoViewController];
    [self setSizeAndAlignVertically:infoViewController];
    [self setAndSaveHorizontalConstraintFor:infoViewController];
    [self slideInFromRight:infoViewController];
}

-(void) addInfoView:(InfoViewController *) infoViewController
{
    [self addChildViewController:infoViewController];
    [self.view addSubview:infoViewController.view];
    infoViewController.delegate = (id)self;
    [infoViewController didMoveToParentViewController:self];    
}
-(void) setSizeAndAlignVertically:(InfoViewController *) infoViewController
{
    [infoViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoViewController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view layoutIfNeeded];
}
-(void) setAndSaveHorizontalConstraintFor:(InfoViewController *)infoViewController
{
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:infoViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:centerXConstraint];
    [self.horizontalConstraints addObject:centerXConstraint];
}
-(void) slideInFromRight:(InfoViewController *) infoViewController
{
    self.currentViewInCenter = infoViewController;
    NSLayoutConstraint *constraintViewComingIn = [self.horizontalConstraints lastObject];
    constraintViewComingIn.constant = self.XPositionRightOfScreen;
    [self.view layoutIfNeeded];
    
    NSLayoutConstraint *constraintViewGoingOut = nil;
    NSLayoutConstraint *constraintViewToRemove = nil;
    UIViewController *infoViewToRemove = nil;
    if (self.infoViews.count > 1){
        constraintViewGoingOut = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:1];
        UIViewController *infoViewGoingOut = (UIViewController *)[self objectIn:self.infoViews atIndexFromLast:1];
        self.currentViewToTheLeft = infoViewGoingOut;
    }
    if (self.infoViews.count > 2) {
        constraintViewToRemove = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:2];
        infoViewToRemove = (UIViewController *)[self objectIn:self.infoViews atIndexFromLast:2];
    }
    
    [UIView animateWithDuration:DURATION_SLIDE delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        constraintViewComingIn.constant = self.XPositionInCenter;
        if (constraintViewGoingOut != nil) {
            constraintViewGoingOut.constant = self.XPositionLeftOfScreen;
        }
        if (constraintViewToRemove != nil) {
            constraintViewToRemove.constant = self.XPositionFarOffLeft;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [infoViewToRemove removeFromParentViewController];
        [infoViewToRemove.view removeFromSuperview];
        [self.view removeConstraint:constraintViewToRemove];
        
        if (self.infoViews.count > MAX_NUMBER_OF_INFOVIEWS) {
            [self.infoViews removeObjectAtIndex:0];
            [self.horizontalConstraints removeObjectAtIndex:0];
        }
    }];
}
-(void) goBackToPreviousInfoView
{
    if (self.infoViews.count < 2) {
        return;
    }
    
    __block InfoViewController *infoViewToRemove = [self.infoViews lastObject];
    NSLayoutConstraint *constraintViewToRemove = [self.horizontalConstraints lastObject];
   
    NSLayoutConstraint * constraintInfoViewComingToCenter = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:1];
    UIViewController *infoViewComingToCenter = (UIViewController *)[self objectIn:self.infoViews atIndexFromLast:1];
    self.currentViewInCenter = infoViewComingToCenter;
    
    if (self.infoViews.count > 2 && self.oldInfoView == nil) {
        self.oldInfoView = (InfoViewController *)[self objectIn:self.infoViews atIndexFromLast:2];
        self.oldInfoViewConstraint = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:2];
        [self addInfoView:self.oldInfoView];
        [self setSizeAndAlignVertically:self.oldInfoView];
        [self.view addConstraint:self.oldInfoViewConstraint];
        self.oldInfoViewConstraint.constant = self.XPositionFarOffLeft;
    }
    
    [UIView animateWithDuration:DURATION_SLIDE delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        constraintViewToRemove.constant = self.XPositionRightOfScreen;
        infoViewToRemove.view.alpha = 0;
        constraintInfoViewComingToCenter.constant = self.XPositionInCenter;
        if (self.oldInfoView != nil) {
            self.oldInfoViewConstraint.constant = self.XPositionLeftOfScreen;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (finished) {
            [infoViewToRemove removeFromParentViewController];
            [infoViewToRemove.view removeFromSuperview];
            infoViewToRemove = nil;
            self.oldInfoView = nil;
            self.oldInfoViewConstraint = nil;
            [self.view removeConstraint:constraintViewToRemove];
            [self.infoViews removeLastObject];
            [self.horizontalConstraints removeLastObject];
        }
    }];
}
-(void) panHappened:(UIPanGestureRecognizer *) sender
{
    CGPoint translation = [sender translationInView:self.view];

    if (self.infoViews.count < 2) {
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        return;
    }
    
    NSLayoutConstraint *constraintInfoViewInCenter = [self.horizontalConstraints lastObject];
    InfoViewController *infoViewInCenter = [self.infoViews lastObject];

    NSLayoutConstraint *constraintInfoViewLeftOfScreen = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:1];
    
    if (self.infoViews.count > 2) {
        if ([sender state] == UIGestureRecognizerStateBegan) {
            self.oldInfoView = (InfoViewController *)[self objectIn:self.infoViews atIndexFromLast:2];
            self.oldInfoViewConstraint = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:2];
            [self addInfoView:self.oldInfoView];
            [self setSizeAndAlignVertically:self.oldInfoView];
            [self.view addConstraint:self.oldInfoViewConstraint];
            self.oldInfoViewConstraint.constant = self.XPositionFarOffLeft;
        }
        self.oldInfoViewConstraint.constant += translation.x;
    }else{
        self.oldInfoView = nil;
        self.oldInfoViewConstraint = nil;
    }
    
    constraintInfoViewInCenter.constant += translation.x;
    constraintInfoViewLeftOfScreen.constant += translation.x;
    
    if (constraintInfoViewLeftOfScreen.constant > self.XPositionInCenter){
        constraintInfoViewLeftOfScreen.constant = self.XPositionInCenter;
        constraintInfoViewInCenter.constant = self.XPositionRightOfScreen;
        if (self.oldInfoView != nil) {
            if (self.oldInfoViewConstraint.constant > self.XPositionLeftOfScreen) {
                self.oldInfoViewConstraint.constant = self.XPositionLeftOfScreen;
            }
        }
    }
    if (constraintInfoViewInCenter.constant < self.XPositionInCenter) {
        constraintInfoViewInCenter.constant = self.XPositionInCenter;
        constraintInfoViewLeftOfScreen.constant = self.XPositionLeftOfScreen;
        if (self.oldInfoView != nil) {
            self.oldInfoViewConstraint.constant = self.XPositionFarOffLeft;
        }
    }
    

    CGFloat alphaConstant = 0.4 / (self.view.frame.size.width/2);
    infoViewInCenter.view.alpha = 1 - constraintInfoViewInCenter.constant * alphaConstant;
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGFloat tippingPointDistance = self.view.frame.size.width/3;
        if (constraintInfoViewInCenter.constant > tippingPointDistance) {
            [self goBackToPreviousInfoView];
        }else{
            [self moveInfoViewsToOriginalPosition];
        }
    }
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];

    
}
-(void) moveInfoViewsToOriginalPosition
{
    NSLayoutConstraint *constraintViewInCenter = [self.horizontalConstraints lastObject];
    UIViewController *infoViewInCenter = [self.infoViews lastObject];
    NSLayoutConstraint *constraintViewLeftOfScreen = (NSLayoutConstraint *)[self objectIn:self.horizontalConstraints atIndexFromLast:1];
    
    [UIView animateWithDuration:DURATION_SLIDE delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        constraintViewInCenter.constant = self.XPositionInCenter;
        constraintViewLeftOfScreen.constant = self.XPositionLeftOfScreen;
        infoViewInCenter.view.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [self.oldInfoView removeFromParentViewController];
        [self.oldInfoView.view removeFromSuperview];
        self.oldInfoView = nil;
        [self.view removeConstraint:self.oldInfoViewConstraint];
        self.oldInfoViewConstraint = nil;
    }];
}
-(void) rightSwipeHappened:(UIGestureRecognizer *)sender
{
    [self goBackToPreviousInfoView];
}
-(void) newInfoViewRequestedFromInfoView:(UIViewController *)infoView
{
    [self presentNewInfoView:(InfoViewController *)infoView];
}
-(void) mediaObjectSelectedInInfoView:(NSString *)media
{
    [self.delegate mediaSelectedForWatching:media];
}
-(void) close:(UITapGestureRecognizer *)sender
{
    [self.delegate removeInfoViewAnimationController];
}
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.view];

    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (CGRectContainsPoint(self.currentViewInCenter.view.frame, touchLocation) || CGRectContainsPoint(self.currentViewToTheLeft.view.frame, touchLocation))
        {
            return NO;
        }
        else{
            return YES;
        }
    }
    return YES;
}

-(id) objectIn:(NSArray *)array atIndexFromLast:(int) index
{
    NSInteger i = array.count - (index+1);
    return [array objectAtIndex:i];
    
}

@end
