//
//  TvContentViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"
#import "ContentViewController.h"
#import "DropDownMenu.h"


@interface TvContentViewController : ContentViewController <ContentDisplayViewDelegate, DropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentPlaceholderScrollView;
@property (weak, nonatomic) IBOutlet DropDownMenu *dropDownMenu;

@end
