//
//  PopOverController2.h
//  PopOverTestProject
//
//  Created by Tomas Nilsson on 10/9/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popOverController2Delegate <NSObject>

-(void) resizeButtonTappedInPopOverController;

@end

@interface PopOverController2 : UIViewController

@property (weak, nonatomic) id <popOverController2Delegate> delegate;

-(void) addNewPopOver:(UIViewController *) popOver;
-(void) goBackToPreviousPopOver;


@end
