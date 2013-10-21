//
//  RootViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"
#import "ContentViewController.h"
#import "PopOverController.h"
#import "InfoViewAnimationController.h"

@interface RootViewController : UIViewController <MainMenuDelegate, ContentViewControllerDelegate, InfoViewAnimationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *mainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *placeholderForMenu;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderLeadingConstraint;

- (IBAction)buttonMenuPressed:(id)sender;
- (IBAction)buttonResizePressed:(id)sender;
- (IBAction)panGestureHappened:(id)sender;
- (IBAction)swipeGestureRightHappened:(id)sender;
- (IBAction)swipeGestureLeftHappened:(id)sender;

@end
