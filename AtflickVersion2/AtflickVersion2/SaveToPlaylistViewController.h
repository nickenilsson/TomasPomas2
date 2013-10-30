//
//  SaveToPlaylistViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 25/10/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveToPlaylistDelegate <NSObject>

-(void) closeSaveToPlayListViewController;

@end

@interface SaveToPlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <SaveToPlaylistDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
