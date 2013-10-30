//
//  ContentViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/2/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate <NSObject>

-(void) presentPopOverViewController:(UIViewController *) viewController;

@end

@interface ContentViewController : UIViewController

@property (weak, nonatomic) id <ContentViewControllerDelegate> delegate;

@end
