//
//  AddToOrSharePopOverViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 25/10/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToOrSharePopOverViewController : UIViewController

-(id)initWithMediaObject:(id) mediaObject;

@property (weak, nonatomic) UIPopoverController *parentPopOverController;

@end
