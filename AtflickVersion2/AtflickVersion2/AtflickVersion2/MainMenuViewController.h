//
//  MainMenuViewController.h
//  VionLabsAtflickVersion1
//
//  Created by Tomas Nilsson on 9/25/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainMenuDelegate <NSObject>

-(void) menuItemSelectedWithIndex: (NSUInteger) index;

@end

@interface MainMenuViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, weak) id <MainMenuDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
