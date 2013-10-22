//
//  InfoViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/16/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"

@protocol InfoViewAnimationControllerDelegate <NSObject>


-(void) removeInfoViewAnimationController;
-(void) mediaSelectedForWatching:(NSString *) media;

@end

@interface InfoViewAnimationController : UIViewController <PopOverViewDelegate, UIGestureRecognizerDelegate>

-(void) presentNewInfoView:(InfoViewController *) infoViewController;

@property (weak, nonatomic) id <InfoViewAnimationControllerDelegate> delegate;

@end
