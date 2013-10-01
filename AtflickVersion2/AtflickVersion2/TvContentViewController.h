//
//  TvContentViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"

@interface TvContentViewController : UIViewController <ContentDisplayViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentPlaceholderScrollView;
- (IBAction)showContentGridStyle:(id)sender;
- (IBAction)showContentOverviewStyle:(id)sender;
- (IBAction)showContentListStyle:(id)sender;
- (IBAction)loadSomething:(id)sender;

@end
