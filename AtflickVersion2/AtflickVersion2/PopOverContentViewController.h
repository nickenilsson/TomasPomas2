//
//  PopOverContentViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/24/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopOverContentDelegate <NSObject>

-(void) popOverMenuItemSelected:(NSNumber *) selection;

@end

@interface PopOverContentViewController : UITableViewController

-(id)initWithMenuTitles:(NSMutableArray *)menuTitles menuOptions:(NSMutableArray *)menuOptions;

@property (weak, nonatomic) id <PopOverContentDelegate> delegate;

@end
