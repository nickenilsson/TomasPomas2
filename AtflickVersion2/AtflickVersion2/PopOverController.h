//
//  PopOverController2.h
//  PopOverTestProject
//
//  Created by Tomas Nilsson on 10/9/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopOverControllerDelegate <NSObject>

-(void) removePopOverController;

@end

@interface PopOverController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <PopOverControllerDelegate> delegate;

-(void) addNewPopOver:(UIViewController *) popOver;
-(void) goBackToPreviousPopOver;

@end
