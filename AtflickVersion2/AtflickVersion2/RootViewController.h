//
//  RootViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"


@interface RootViewController : UIViewController <MainMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *placeholderForViews;
@property (weak, nonatomic) IBOutlet UIView *placeholderForMenu;
@property (weak, nonatomic) IBOutlet UIView *topBar;
- (IBAction)buttonMenuPressed:(id)sender;
- (IBAction)buttonResizePressed:(id)sender;
- (IBAction)panGestureHappened:(id)sender;
- (IBAction)swipeGestureRightHappened:(id)sender;
- (IBAction)swipeGestureLeftHappened:(id)sender;

@end
