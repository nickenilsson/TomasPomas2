//
//  ViewControllerHandler.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/2/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentViewController.h"

@interface ViewControllerHandler : NSObject

-(ContentViewController *) contentViewControllerCorrespondingToIndex:(int) index;

-(UIViewController *) popUpViewForObjectOfType:(int) type;



@end
