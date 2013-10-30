//
//  PopOverViewViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/15/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopOverViewDelegate <NSObject>

-(void) presentPopOver:(UIViewController *) popOver;

@end

@interface PopOverView : UIViewController

@property (weak, nonatomic) id <PopOverViewDelegate> delegate;

@end
