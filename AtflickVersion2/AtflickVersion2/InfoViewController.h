//
//  PopOverViewViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/15/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopOverViewDelegate <NSObject>

-(void) newInfoViewRequestedFromInfoView:(UIViewController *) infoView;
-(void) mediaObjectSelectedInInfoView:(NSString *) media;

@end

@interface InfoViewController : UIViewController

@property (weak, nonatomic) id <PopOverViewDelegate> delegate;

@end
