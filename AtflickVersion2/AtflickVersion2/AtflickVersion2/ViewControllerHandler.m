//
//  ViewControllerHandler.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/2/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "ViewControllerHandler.h"
#import "TvContentViewController.h"
#import "FilmContentViewController.h"

@implementation ViewControllerHandler

-(ContentViewController *) contentViewControllerCorrespondingToIndex:(int)index
{
    ContentViewController *viewController;
    switch (index) {
        case 0:{
            viewController = [[TvContentViewController alloc] init];
            break;
        }
        case 1:{
            viewController = [[FilmContentViewController alloc] init];
            break;
        }
        default:
            viewController = [[TvContentViewController alloc] init];
            break;
    }
    return viewController;
}

-(UIViewController *) popUpViewForObjectOfType:(int) type
{
    
    return nil;
}


@end
