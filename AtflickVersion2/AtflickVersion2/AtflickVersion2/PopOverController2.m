//
//  PopOverController2.m
//  PopOverTestProject
//
//  Created by Tomas Nilsson on 10/9/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "PopOverController2.h"

#define DURATION_POP_OVER_SLIDE 0.1
#define MAXIMUM_NUMBER_OF_POP_OVERS 10

@interface PopOverController2 ()

@property (nonatomic) CGFloat firstPositionDistanceToCenter;
@property (nonatomic) CGFloat secondPositionDistanceToCenter;
@property (nonatomic) CGFloat thirdPositionDistanceToCenter;
@property (nonatomic) CGFloat fourthPositionDistanceToCenter;
@property (nonatomic, strong) NSMutableArray *centerXConstraints;
@property (nonatomic, strong) NSMutableArray *popOvers;
@property (nonatomic, strong) UITapGestureRecognizer *goBackTapGesture;

@end

@implementation PopOverController2

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
    [self.view layoutIfNeeded];

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.centerXConstraints = [NSMutableArray arrayWithCapacity:10];
    self.popOvers = [NSMutableArray arrayWithCapacity:10];
    self.goBackTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackToPreviousPopOver)];
}

-(void) viewWillLayoutSubviews
{
    NSLog(@"self.view = %@", self.view);
    
    CGFloat distance1 = self.view.bounds.size.width;
    CGFloat distance3 = -self.view.bounds.size.width*0.8;
    CGFloat distance4 = -2*self.view.bounds.size.width;
    
    if(self.firstPositionDistanceToCenter != distance1){
        self.firstPositionDistanceToCenter = distance1;
        self.thirdPositionDistanceToCenter = distance3;
        self.fourthPositionDistanceToCenter = distance4;
        [self updateAllConstraints];
        [self.view layoutIfNeeded];
    }
    self.secondPositionDistanceToCenter = 0;

}
-(void) viewDidLayoutSubviews
{
    
}

-(void) updateAllConstraints
{
    if(self.popOvers.count > 1){
        NSInteger indexSecondToLast = self.popOvers.count - 2;
        NSLayoutConstraint *constraintImageStandingBy = [self.centerXConstraints objectAtIndex:indexSecondToLast];
        NSLog(@"self.thirdPositionDistanceToCenter = %f", self.thirdPositionDistanceToCenter);
        constraintImageStandingBy.constant = self.thirdPositionDistanceToCenter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addNewPopOver:(UIViewController *) popOver
{
    [self addChildViewController:popOver];
    [self.view addSubview:popOver.view];
    [popOver didMoveToParentViewController:self];
    [self.popOvers addObject:popOver];

    [popOver.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setFrameForPopOver:popOver];
    
    __block NSLayoutConstraint *constraintIncomingPopOver = [self.centerXConstraints lastObject];
   
    constraintIncomingPopOver.constant = self.firstPositionDistanceToCenter;
    [self.view layoutIfNeeded];

    __block NSLayoutConstraint *constraintMovingOffScreenPopOver = nil;
    __block NSLayoutConstraint *constraintDisappearingPopOver = nil;
    if(self.popOvers.count > 1){
        NSInteger secondToLastIndex = self.popOvers.count - 2;
        constraintMovingOffScreenPopOver = [self.centerXConstraints objectAtIndex:secondToLastIndex];
        UIViewController *popOverMovingOffScreen = [self.popOvers objectAtIndex:secondToLastIndex];
        [popOverMovingOffScreen.view addGestureRecognizer:self.goBackTapGesture];
        
        if(self.popOvers.count > 2){
            NSInteger thirdToLastIndex = self.popOvers.count - 3;
            constraintDisappearingPopOver = [self.centerXConstraints objectAtIndex:thirdToLastIndex];
        }
    }
    
    [UIView animateWithDuration:DURATION_POP_OVER_SLIDE delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        constraintIncomingPopOver.constant = self.secondPositionDistanceToCenter;
        if (constraintMovingOffScreenPopOver != nil) {
            constraintMovingOffScreenPopOver.constant = self.thirdPositionDistanceToCenter;
            if (constraintDisappearingPopOver != nil) {
                constraintDisappearingPopOver.constant = self.fourthPositionDistanceToCenter;
            }
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (finished) {
            if (constraintDisappearingPopOver != nil) {
                NSInteger indexOfDisappearingPopOver = self.popOvers.count - 3;
                UIViewController *disappearingPopOver = [self.popOvers objectAtIndex:indexOfDisappearingPopOver];
                [disappearingPopOver removeFromParentViewController];
                [disappearingPopOver.view removeFromSuperview];
            }
        }
    }];
    
    if(self.popOvers.count > MAXIMUM_NUMBER_OF_POP_OVERS){
        [self.popOvers removeObjectAtIndex:0];
        [self.centerXConstraints removeObjectAtIndex:0];
    }
}
-(void) goBackToPreviousPopOver
{
    if (self.popOvers.count < 2) {
        return;
    }
    
    __block NSLayoutConstraint *constraintDisappearingPopOver = [self.centerXConstraints lastObject];
    __block UIViewController *disappaearingPopOver = [self.popOvers lastObject];
    
    NSInteger secondToLastIndex = self.popOvers.count - 2;

    __block NSLayoutConstraint *constraintComingInPopOver = [self.centerXConstraints objectAtIndex:secondToLastIndex];
    __block UIViewController *comingInToViewPopOver = [self.popOvers objectAtIndex:secondToLastIndex];
    [comingInToViewPopOver.view removeGestureRecognizer:self.goBackTapGesture];
    
    __block UIViewController *comingToStandByPopOver = nil;
    __block NSLayoutConstraint *constraintComingToStandbyPopOver = nil;
    
    if (self.popOvers.count > 2) {
        NSInteger thirdToLastIndex = self.popOvers.count - 3;
        comingToStandByPopOver = [self.popOvers objectAtIndex:thirdToLastIndex];
        constraintComingToStandbyPopOver = [self.centerXConstraints objectAtIndex:thirdToLastIndex];
        [self addChildViewController:comingToStandByPopOver];
        [self.view addSubview:comingToStandByPopOver.view];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:comingToStandByPopOver.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:comingToStandByPopOver.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:comingToStandByPopOver.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.view addConstraint:constraintComingToStandbyPopOver];
        
        constraintComingToStandbyPopOver.constant = self.fourthPositionDistanceToCenter;
        [comingToStandByPopOver.view addGestureRecognizer:self.goBackTapGesture];
        
        [self.view layoutIfNeeded];
    }
    
    [UIView animateWithDuration:DURATION_POP_OVER_SLIDE delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        constraintDisappearingPopOver.constant = self.firstPositionDistanceToCenter;
        constraintComingInPopOver.constant = self.secondPositionDistanceToCenter;
        if (comingToStandByPopOver != nil) {
            constraintComingToStandbyPopOver.constant = self.thirdPositionDistanceToCenter;
        }
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        if (finished) {
            [disappaearingPopOver removeFromParentViewController];
            [disappaearingPopOver.view removeFromSuperview];
            [self.popOvers removeLastObject];
            [self.centerXConstraints removeLastObject];
        }
    }];
    
}
-(void) setFrameForOldPopOver:(UIViewController *) popOver
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}
-(void) setFrameForPopOver:(UIViewController *) popOver
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:popOver.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.centerXConstraints addObject:centerXConstraint];
    [self.view addConstraint: centerXConstraint];
}

-(void) animatingFrame
{
    
}



@end
